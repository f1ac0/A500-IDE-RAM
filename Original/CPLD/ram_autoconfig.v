
module ram_autoconfig(
	input [23:16] AH,
	input [6:1] AL,
	input [15:13] D_i,
	input _RST,
	input _UDS,
	input RW,
	input _configin,
	output _configout,
	output [15:12] D_o,
	output autoconfig_oe,
//	output OVR, //positive logic here !
	output DTACK, //positive logic here !
	output ram1ce
//	output ram2ce
	);

	
//autoconfig
   reg configured = 1'b0;
   reg shutup = 1'b0;
	reg [23:21] base_address;
   wire autoconfig_access = (AH[23:16] == 8'hE8) & !configured & !shutup & !_configin; //accessing autoconfig space
   wire autoconfig_read = autoconfig_access & RW;
	wire autoconfig_write = autoconfig_access & !RW;
	reg  [3:0] autoconfig_d;

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

//response from our device
	assign D_o[15:12] = autoconfig_d[3:0]; //autoconfig data
	assign autoconfig_oe = autoconfig_read;
	assign _configout = !(configured | shutup);
	assign ram1ce = configured & (AH[23:21]==base_address[23:21]); //Lower 2MB chip // ==3'b001
//	assign ram2ce = 1'b0; //configured & (AH[23:21]==3'b010); //Upper 2MB chip
//	assign OVR = 1'b0; //ram1ce;  //chipset override, positive logic here !
	assign DTACK = autoconfig_access | ram1ce; // | ram2ce;

endmodule
