// first RAM autoconfig code adapted from Sukkopera
// https://github.com/SukkoPera/OpenAmiga500FastRamExpansion
// OpenAmiga500FastRamExpansion is CERN OHL 1.2

module ram_autoconfig_original(
	input [23:16] AH,
	input [6:1] AL,
	input [15:13] D,
	input cpu_nas,
	input cpu_nlds,
	input cpu_nuds,
	input cpu_clk,
	input cpu_nreset,
	input _configin,
	output _configout,
	output [15:12] autoconfig_d,
	output autoconfig_oe,
//	output OVR, //positive logic here !
	output DTACK, //positive logic here !
	output ram1ce
//	output ram2ce
	);

	reg configured = 1'b0;
	reg shutup = 1'b0;
	reg [23:21] base_address;
	reg [3:0] autoconfig_dz; // data out
	wire autoconfig_access = ({AH[23:16]} == {8'hE8}) & !configured & !shutup & !_configin; //accessing autoconfig space
//	wire [5:0] low_addr = AL;

	// make clocked cpu_nas_z
	reg cpu_nas_z; // cpu /AS with 1 clock latency
	always @(posedge cpu_clk)
	begin
		cpu_nas_z <= cpu_nas;
	end

	// detect if current cycle is read or write cycle
	reg read_cycle; // if current cycle is read cycle
	reg write_cycle;
	always @(posedge cpu_clk, posedge cpu_nas)
	begin
		if( cpu_nas==1 ) // async reset on end of /AS strobe
		begin
			read_cycle  <= 0; // end of cycles
			write_cycle <= 0;
		end
		else // sync beginning of cycle
		begin
			if( cpu_nas==0 && cpu_nas_z==1 ) // beginning of /AS strobe
			begin
				if( (cpu_nlds&cpu_nuds)==0 )
					read_cycle <= 1;
				else
					write_cycle <= 1;
			end
		end
	end

	// autoconfig data forming
	always @(negedge cpu_nuds)
	begin
		case( AL[6:1] ) //low_addr )
			'h00: autoconfig_dz <= 4'b1110; // $00 : Current style board, load into memory free list
			'h01: autoconfig_dz <= 4'b0110; // $02 : 0110 for 2MB, 0111 for 4MB, 0000 for 8MB
			'h02: autoconfig_dz <= 4'hF; // $04 : Product number
			'h03: autoconfig_dz <= 4'hF; // $06 : Product number
			'h04: autoconfig_dz <= 4'h3; // $08 : Can be shut up, in 8Meg space
//			'h0a: autoconfig_dz <= 4'hF; // $0a : reserved
			'h08: autoconfig_dz <= 4'hA; // $10 : Mfg # high byte
			'h09: autoconfig_dz <= 4'hF; // $12 : Mfg # high byte
			'h0a: autoconfig_dz <= 4'hF; // $14 : Mfg # low byte
			'h0b: autoconfig_dz <= 4'hF; // $16 : Mfg # low byte
//			'h11: autoconfig_dz <= 4'he; // $22 : serial number
//			'h12: autoconfig_dz <= 4'hb; // $24 : serial number
//			'h13: autoconfig_dz <= 4'h7; // $26 : serial number
			'h20: autoconfig_dz <= 4'h0; // $40 : Control status register
			'h21: autoconfig_dz <= 4'h0; // $42 : Control status register
			default: autoconfig_dz <= 4'hF;
		endcase
	end

	// autoconfig cycle on/off
	always @(posedge write_cycle,negedge cpu_nreset)
	begin
		if( !cpu_nreset ) begin // reset - begin autoconf
			configured <= 1'b0;
			shutup <= 1'b0;
		end else	begin
			if( autoconfig_access && AL[6:1]==6'b100100 ) begin // $E80048
				configured <= 1;
				base_address[23:21] <= D[15:13];
			end
			if( autoconfig_access && AL[6:1]==6'b100110 ) // $E8004C
				shutup <= 1;
		end
	end

	//response from our device
	assign autoconfig_d[15:12] = autoconfig_dz[3:0]; //autoconfig data
	assign autoconfig_oe = read_cycle & autoconfig_access;
	assign _configout = !(configured | shutup);
	assign ram1ce = configured & (AH[23:21]==base_address[23:21]); //Lower 2MB chip // ==3'b001
//	assign ram2ce = 1'b0; //configured & (AH[23:21]==3'b010); //Upper 2MB chip
//	assign OVR = 1'b0; //ram1ce;  //chipset override, positive logic here !
	assign DTACK = autoconfig_oe | ram1ce; // | ram2ce;


endmodule
