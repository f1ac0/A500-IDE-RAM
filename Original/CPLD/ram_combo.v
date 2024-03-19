
module ram_combo(
	input [23:12] AH,
	input [6:1] AL,
	input [15:13] D_i,
	input _RST,
	input CLK,
	input _UDS,
	input RW,
	input _configin,
	output _configout,
	output [15:12] D_o,
	output config_oe,
	output OVR, //positive logic here !
	output DTACK, //positive logic here !
	output ram1ce
//	output ram2ce
	);

//ram mode
	reg ram_mode = 1'b0;	//0 for fast autofonfig (default), 1 for ranger+maprom
	reg ram_mode_select = 1'b0;
	wire mode_fastautoconf = !ram_mode;
	wire mode_rangermaprom = ram_mode;
	
//autoconfig
	reg configured = 1'b0;
	reg shutup = 1'b0;
	reg [3:0] autoconfig_d;
	reg [23:21] base_address;
	wire autoconfig_access = mode_fastautoconf & (AH[23:16] == 8'hE8) & !configured & !shutup & !_configin; //accessing autoconfig space
	wire autoconfig_read = autoconfig_access & RW;
	wire autoconfig_write = autoconfig_access & !RW;
	wire ram2_range = configured & (AH[23:21]==base_address[23:21]); //Lower 2MB

always @(negedge _UDS or negedge _RST) begin
	if (!_RST) begin
		configured <= 1'b0;
		shutup <= 1'b0;
	end else begin
		if (autoconfig_write) begin
			case ( AL[6:1] )
				'h24: begin // $48-4b : Base address register
						base_address[23:21] <= D_i[15:13];
						configured <= 1'b1;
					end
				//'h25: base_address[3:0] <= D[15:12]; // $4a  : Base address register
				'h26: shutup <= 1'b1; // $4c-4f : Optional "shut up" address
			endcase
		end

		case ( AL[6:1] )
			'h00: autoconfig_d <= 4'b1110; // $00 : Current style board, load into memory free list
			'h01: autoconfig_d <= 4'b0110; // $02 : 0110 for 2MB, 0111 for 4MB, 0000 for 8MB
			'h02: autoconfig_d <= 4'hF; // $04 : Product number
			'h03: autoconfig_d <= 4'hF; // $06 : Product number
			'h04: autoconfig_d <= 4'h3; // $08 : Can be shut up, in 8Meg space
//			'h0a: autoconfig_d <= 4'hF; // $0a : reserved
			'h08: autoconfig_d <= 4'hA; // $10 : Mfg # high byte
			'h09: autoconfig_d <= 4'hF; // $12 : Mfg # high byte
			'h0a: autoconfig_d <= 4'hF; // $14 : Mfg # low byte
			'h0b: autoconfig_d <= 4'hF; // $16 : Mfg # low byte
//			'h11: autoconfig_d <= 4'he; // $22 : serial number
//			'h12: autoconfig_d <= 4'hb; // $24 : serial number
//			'h13: autoconfig_d <= 4'h7; // $26 : serial number
			'h20: autoconfig_d <= 4'h0; // $40 : Control status register
			'h21: autoconfig_d <= 4'h0; // $42 : Control status register
			default: autoconfig_d <= 4'hF;
		endcase
	end
end

//maprom
	reg [1:0] maprom_written = 2'b0;
	reg maprom_on = 1'b0;
	wire ram9_range = mode_rangermaprom & ( AH[23:20]==4'b1100 | AH[23:19]==5'b11010 ); //C00000-D7FFFF, 1.5M
	wire rom9_range = mode_rangermaprom & ( AH[23:19]==5'b11111 ); //F80000-FFFFFF, .5M
	wire maprom_write = rom9_range & !RW & !maprom_on; //write protect when active
	wire maprom_read = rom9_range & maprom_on;

//maprom reset timer
	reg [26:0] rst_timer;
	wire rst_3s= rst_timer[24] & rst_timer[22];
	wire rst_6s= rst_timer[25] & rst_timer[23];
	wire rst_10s= rst_timer[26];
	always @(posedge CLK)
	begin
		if(_RST)
			rst_timer <= 27'b0;
		else
			rst_timer <= rst_timer+1;
	end

//control register
	wire control_access = AH[23:12] == 12'hE9C;
	wire control_read = control_access & RW;
	wire control_write = control_access & !RW;
	wire [3:0] control_d = {maprom_on, ram_mode, &(maprom_written), ram_mode_select}; //2'b0};

//control commands and mode/maprom activation
	// ram_mode select = write in control or toggle when 10s reset
	wire ram_mode_set = !_UDS & control_write | rst_10s;
	always @(posedge ram_mode_set)
	begin
		if( control_write )
			ram_mode_select <= D_i[14];
		else
			ram_mode_select <= !ram_mode_select;
	end
	//ram_mode set at reset
	always @(posedge _RST)
		ram_mode <= ram_mode_select;
	// maprom set = when ROM written
	// maprom reset = write in control or 6s reset
	wire maprom_rst = !_UDS & control_write & !D_i[15] | rst_6s;
	always @(negedge _UDS or posedge maprom_rst)
	begin
		if(maprom_rst) begin
			maprom_written <= 2'b0;
		end else	begin
			if( maprom_write ) begin // maprom write
				if(~&(maprom_written)) //sample multiple writes otherwise false positives during power up
					maprom_written <= maprom_written+1;
			end
		end
	end
	//maprom activate at reset
	//maprom deactivate at 3s reset
	always @(negedge _RST or posedge rst_3s) begin
		if(rst_3s)
			maprom_on <= 0;
		else
			maprom_on <= ram_mode_select & &(maprom_written);
	end

//response from our device
	assign D_o[15:12] = autoconfig_read ? autoconfig_d[3:0] : (control_read ? control_d : 4'bzzzz); //autoconfig data or control registers
	assign config_oe = autoconfig_read | control_read;
	assign _configout = !(configured | shutup | (!mode_fastautoconf & !_configin));
	assign ram1ce = ram2_range | ram9_range | maprom_write | maprom_read; //Lower 2MB
//	assign ram2ce = 1'b0; //configured & (AH[23:21]==3'b010); //Upper 2MB chip
	assign OVR = (ram9_range | maprom_write | maprom_read | control_access); //chipset override, positive logic here !
	assign DTACK = autoconfig_access | control_access | ram1ce; // | ram2ce;

endmodule
