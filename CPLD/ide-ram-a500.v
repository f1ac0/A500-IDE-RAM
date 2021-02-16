// Inspired by original design and code of ide68k v425 by Mika Leinonen
// now offline :http://www.mkl211015.altervista.org/ide/ide68k.html
// https://web.archive.org/web/20200221025111/http://www.mkl211015.altervista.org/ide/ide68k.html
// Additional RAM idea inspired by Sector101
// https://blog.sector101.co.uk/2019/07/20/amiga-500-2mb-handwired-fastram-expansion/
// first RAM autoconfig code adapted from Sukkopera
// https://github.com/SukkoPera/OpenAmiga500FastRamExpansion
// Amiga Memory map
// https://amigacoding.com/index.php?title=Amiga_memory_map
// MapROM
// Use mapROM program kindly opensourced by Paul RASPA:
// https://github.com/PR77/A600_ACCEL_RAM/tree/master/Software
// mapROM -f Files:kickstart-image-not-swapped-nor-split.rom
// then reset the system
//
// Schematic and PCB converted and merged in KiCAD, code converted to Verilog, merged, adapted, and everything tested by FLACO 2020
// This file Created 25-Apr-2020 10:08 AM
//
// ide68k license is unknown ; OpenAmiga500FastRamExpansion is CERN OHL 1.2
// 
`define RAM_COMBO 1
//`define RAM_AUTOCONFIG 1
//`define RAM_AUTOCONFIG_ORIGINAL 1
//`define RAM_RANGER_MAPROM 1
//`define RAM_NONE 1
`define OPTPIN_LED 1
//`define OPTPIN_CONFIG 1

module ide_ram_a500(
	input nas,
	input r_w,
	input nuds,
	input nlds,
	input nreset,
	input cpuclk7,
	input [23:12] AH,
	input [6:1] AL, //6,5,1 added for RAM
	inout [15:0] D,
//	input iordy_na,
	input ide_intrq,
	input ndaspin,
	inout [15:0] DD,
	output reg nidereset,
	output reg [2:0] DA,
	output reg [1:0] _CS,
	output niow,
	output nior,
	output ndtack,
	output ndtack2,
	output _ovr,
	output _ovr2,
	output _ovr3,
	output nint2,
	output nint2_2,
	output led,
`ifdef OPTPIN_LED
	output OPTPIN_I,
	output OPTPIN_O,
`endif
`ifdef OPTPIN_CONFIG
	input OPTPIN_I,
	output OPTPIN_O,
`endif
	output ram1ce, //RAM
	output ram2ce //RAM
	);


//RAM
	wire ram_d_OE;
	wire [15:12] ram_d;
	wire ram_ovr_range;
	wire ram_dtack_range;
	wire _configin;
	wire _configout;
	assign ram2ce=1'b0;
	
`ifdef RAM_COMBO
	//ram selectable autoconfig or ranger+maprom
	ram_combo ram(
		AH[23:12],
		AL[6:1],
		D[15:13],
		nreset,
		nuds,
		r_w,
		_configin,
		_configout,
		ram_d,
		ram_d_OE,
		ram_ovr_range,		
		ram_dtack_range,		
		ram1ce
//		ram2ce
	);
`endif
`ifdef RAM_AUTOCONFIG
	//ram_autoconfig
	assign ram_ovr_range=1'b0;
	ram_autoconfig ram(
		AH[23:16],
		AL[6:1],
		D[15:13],
		nreset,
		nuds,
		r_w,
		_configin,
		_configout,
		ram_d,
		ram_d_OE,
//		ram_ovr_range,		
		ram_dtack_range,		
		ram1ce
//		ram2ce
	);
`endif
`ifdef RAM_AUTOCONFIG_ORIGINAL
	//ram_autoconfig_original
	assign ram_ovr_range=1'b0;
	ram_autoconfig_original ram(
		AH[23:16],
		AL[6:1],
		D[15:13],
		nas,
		nlds,
		nuds,
		cpuclk7,
		nreset,
		_configin,
		_configout,
		ram_d[15:12],
		ram_d_OE,
		ram_dtack_range,		
		ram1ce
//		ram2ce
	);
`endif
`ifdef RAM_RANGER_MAPROM
	//ram_ranger_maprom
//	assign ram_d_OE=1'b0;
	assign _configout=1'b0;
	assign ram_dtack_range=1'b0;
	ram_ranger_maprom ram(
		AH[23:12],
		nuds,
		nreset,
		r_w,
		ram_d[15:12],
		ram_d_OE,
		ram_ovr_range,
		ram1ce
	);
`endif
`ifdef RAM_NONE
	assign ram_ovr_range=1'b0;
	assign _configout=1'b0;
	assign ram_dtack_range=1'b0;
	assign ram1ce=1'b0;
	assign ram_d_OE=1'b0;
`endif

//IDE
	wire [15:0] dd_ZD;
	wire [7:0] dl_ZD;
	reg [15:8] dh_ZD;
	reg [2:0] snr;
	reg [2:0] stidreg;
	reg [2:0] stidreg_D;
   wire int2, dtack, ovr_range,
	 dd8_OE_ctrl, d0_OE_ctrl,
	 dd0_OE_ctrl, d8_OE_ctrl;
   reg n_reset_clocked, daspi, dasp_s,
	 ledst1_D, ledst0_D, Xled_OE, bit_from_sm,
	 not_nas_at_last_clk_rise, irq_synch0,
	 forceasif_ideintrq_DA8000, intrq, lastbitda8000,
	 int2_DA9000, int2generationenable_DAA000,
	 int2generationenable_DAA000_D, int2_DA9000_D,
	 forceasif_ideintrq_DA8000_D, ledst0, ledst1,
	 n_reset_clocked_D, Xledpos, Xled_ZD;

   // initial {snr[0], snr[1], snr[2], n_reset_clocked, daspi,
   //       dasp_s, not_nas_at_last_clk_rise, irq_synch0,
   //       forceasif_ideintrq_DA8000, intrq, lastbitda8000,
   //       int2_DA9000, int2generationenable_DAA000, stidreg[0],
   //       stidreg[1], stidreg[2], ledst0, ledst1, _CS[0], _CS[1],
   //       DA[0], DA[1], DA[2], nidereset} = 24'h0;

   assign Xled = (Xled_OE) ? Xled_ZD : 1'bz;
   assign nint2_2 = (int2) ? 1'b0 : 1'bz;
   assign nint2 = (int2) ? 1'b0 : 1'bz;
   assign _ovr3 = (ovr_range) ? 1'b0 : 1'bz;
   assign _ovr2 = (ovr_range) ? 1'b0 : 1'bz;
   assign _ovr = (ovr_range) ? 1'b0 : 1'bz;
   assign ndtack2 = (dtack) ? 1'b0 : 1'bz;
   assign ndtack = (dtack) ? 1'b0 : 1'bz;
	assign DD[15:8] = (dd8_OE_ctrl) ? dd_ZD[15:8] : 8'bz;
	assign DD[7:0] = (dd0_OE_ctrl) ? dd_ZD[7:0] : 8'bz;
   assign D[15:12] = (d8_OE_ctrl) ? dh_ZD[15:12] : (ram_d_OE ? ram_d[15:12] : 4'bz);
	assign D[11:8] = (d8_OE_ctrl) ? dh_ZD[11:8] : 4'bz;
	assign D[7:0] = (d0_OE_ctrl) ? dl_ZD[7:0] : 8'bz;


	always @(posedge cpuclk7) begin
		snr[0] <= nreset;
		snr[1] <= snr[0];
		snr[2] <= snr[1];
      n_reset_clocked <= n_reset_clocked_D;
	end

	always @(posedge cpuclk7 or negedge n_reset_clocked)
		if (!n_reset_clocked) begin
			daspi <= 1'h0;
			dasp_s <= 1'h0;
			nidereset <= 1'h0;
			{ledst1, ledst0} <= 2'h0;
			irq_synch0 <= 1'h0;
			intrq <= 1'h0;
			not_nas_at_last_clk_rise <= 1'h0;
		end else begin
			daspi <= !ndaspin;
			dasp_s <= daspi;
			nidereset <= 1'b1;
			{ledst1, ledst0} <= {ledst1_D, ledst0_D};
			irq_synch0 <= ide_intrq;
			intrq <= irq_synch0;
			not_nas_at_last_clk_rise <= !nas;
		end

	always @(negedge nas or negedge n_reset_clocked)
		if (!n_reset_clocked) begin
			DA[2] <= 1'h1;
			DA[1] <= 1'h1;
			DA[0] <= 1'h1;
			_CS[1] <= 1'h1;
			_CS[0] <= 1'h1;
		end else begin
			DA[2] <= AL[4];
			DA[1] <= AL[3];
			DA[0] <= AL[2];
			_CS[1] <= ! (AH[23:12] == 12'b1101_1010_0001 | AH[23:12] == 12'b1101_1010_0011);
			_CS[0] <= ! (AH[23:12] == 12'b1101_1010_0000 | AH[23:12] == 12'b1101_1010_0010);
		end
 
	always @(posedge nas or negedge n_reset_clocked)
		if (!n_reset_clocked) begin
			forceasif_ideintrq_DA8000 <= 1'h0;
			lastbitda8000 <= 1'h0;
			int2_DA9000 <= 1'h0;
			int2generationenable_DAA000 <= 1'h0;
			stidreg[2:0] <= 3'h0;
		end else begin
			forceasif_ideintrq_DA8000 <= forceasif_ideintrq_DA8000_D;
			lastbitda8000 <= intrq | forceasif_ideintrq_DA8000;
			int2_DA9000 <= int2_DA9000_D;
			int2generationenable_DAA000 <= int2generationenable_DAA000_D;
			stidreg[2:0] <= stidreg_D[2:0];
		end


// Start of original equations

   always @(snr[1] or snr[2] or n_reset_clocked) begin
      n_reset_clocked_D = 1'b0;
      if (snr[1] == snr[2]) begin
	 n_reset_clocked_D = snr[2];
      end else begin
	 n_reset_clocked_D = n_reset_clocked;
      end
   end
   assign led = !dasp_s;


   always @(ledst0 or ledst1 or dasp_s) begin
      {Xled_ZD, Xledpos, Xled_OE, ledst1_D, ledst0_D} = 5'b0_0000;
      case ({ledst1, ledst0})
      2'b00: begin
	    Xled_ZD = 1'b0;
	    Xledpos = 1'b1;
	    Xled_OE = 1'b1;
	    if (dasp_s) begin
	       {ledst1_D, ledst0_D} = 2'b00;
	    end else begin
	       {ledst1_D, ledst0_D} = 2'b01;
	    end
	 end
      2'b01: begin
	    Xled_ZD = 1'b1;
	    Xledpos = 1'b1;
	    Xled_OE = 1'b1;
	    {ledst1_D, ledst0_D} = 2'b10;
	 end
      2'b10: begin
	    Xled_ZD = 1'b1;
	    Xledpos = 1'b1;
	    Xled_OE = 1'b0;
	    {ledst1_D, ledst0_D} = 2'b11;
	 end
      2'b11: begin
	    Xled_ZD = 1'b1;
	    Xledpos = 1'b0;
	    Xled_OE = 1'b0;
	    if (dasp_s) begin
	       {ledst1_D, ledst0_D} = 2'b00;
	    end else begin
	       {ledst1_D, ledst0_D} = 2'b11;
	    end
	 end
      endcase
   end


   always @(stidreg[0] or stidreg[1] or stidreg[2] or AL[3] or AH[16] or AH[17] or
	 AH[18] or AH[19] or AH[20] or AH[21] or AH[22] or AH[23] or r_w) begin
      {bit_from_sm, stidreg_D[2:0]} = 4'b0000;
      case (stidreg[2:0])
      3'b110: begin
	    bit_from_sm = 1'b1;
	    stidreg_D[2:0] = 3'b000;
	 end
      3'b111: begin
	    bit_from_sm = 1'b1;
	    stidreg_D[2:0] = 3'b000;
	 end
      3'b000: begin
	    bit_from_sm = 1'b1;
	    if (AH[23:16] == 8'b1101_1110 & !AL[3]) begin
	       stidreg_D[2:0] = 3'b001;
	    end else begin
	       stidreg_D[2:0] = 3'b000;
	    end
	 end
      3'b001: begin
	    bit_from_sm = 1'b1;
	    if (AH[23:16] == 8'b1101_1110 & !r_w) begin
	       stidreg_D[2:0] = 3'b010;
	    end else begin
	       stidreg_D[2:0] = 3'b001;
	    end
	 end
      3'b010: begin
	    bit_from_sm = 1'b1;
	    if (AH[23:16] == 8'b1101_1110 & r_w) begin
	       stidreg_D[2:0] = 3'b011;
	    end else begin
	       stidreg_D[2:0] = 3'b010;
	    end
	 end
      3'b011: begin
	    bit_from_sm = 1'b1;
	    if (AH[23:16] == 8'b1101_1110 & !r_w) begin
	       stidreg_D[2:0] = 3'b010;
	    end else if (AH[23:16] == 8'b1101_1110 & r_w) begin
	       stidreg_D[2:0] = 3'b100;
	    end else begin
	       stidreg_D[2:0] = 3'b011;
	    end
	 end
      3'b100: begin
	    bit_from_sm = 1'b0;
	    if (AH[23:16] == 8'b1101_1110 & !r_w) begin
	       stidreg_D[2:0] = 3'b010;
	    end else if (AH[23:16] == 8'b1101_1110 & r_w) begin
	       stidreg_D[2:0] = 3'b101;
	    end else begin
	       stidreg_D[2:0] = 3'b100;
	    end
	 end
      3'b101: begin
	    bit_from_sm = 1'b1;
	    if (AH[23:16] == 8'b1101_1110 & !r_w) begin
	       stidreg_D[2:0] = 3'b010;
	    end else begin
	       stidreg_D[2:0] = 3'b101;
	    end
	 end
      endcase
   end
	
   assign ovr_range = AH[23:16] == 8'b1101_1110
	 | AH[23:16] == 8'b1101_1010 | AH[23:16] == 8'b1101_1001 | AH[23:16] == 8'b1101_1011 | ram_ovr_range;
   assign dtack = !nas & ( ovr_range | ram_dtack_range );
   assign nior = ! ( not_nas_at_last_clk_rise & !nas & r_w & AH[23:14] == 10'b11_0110_1000 );
   assign niow = ! ( not_nas_at_last_clk_rise & !nas & !r_w & AH[23:14] == 10'b11_0110_1000 );
   assign d8_OE_ctrl = r_w & !nuds & !nas & (AH[23:14] == 10'b11_0110_1000 | AH[23:14] == 10'b11_0110_1010 |
	 AH[23:16] == 8'b1101_1110);
   assign d0_OE_ctrl = r_w & !nlds & !nas & (AH[23:12] == 12'b1101_1010_0010 | AH[23:12] == 12'b1101_1010_0011);
   assign dl_ZD[7:0] = DD[15:8];
   assign dd8_OE_ctrl = !r_w & !nas & (AH[23:12] == 12'b1101_1010_0010 | AH[23:12] == 12'b1101_1010_0011);
   assign dd0_OE_ctrl = !r_w & !nas & AH[23:14] == 10'b11_0110_1000;
   assign dd_ZD[15:8] = D[7:0];
   assign dd_ZD[7:0] = D[15:8];


   always @(AH[12] or AH[13] or AH[14] or AH[15] or AH[16] or AH[17] or AH[18] or AH[19] or AH[20] or AH[21]
	 or AH[22] or AH[23] or DD[0] or DD[1] or DD[2] or DD[3] or DD[4] or DD[5] or DD[6]) begin
      dh_ZD[14:8] = 7'b000_0000;
      if (AH[23:12] == 12'b1101_1010_1000 | AH[23:12] == 12'b1101_1010_1001 | AH[23:12] == 12'b1101_1010_1010 | AH[23:12] ==
	    12'b1101_1010_1011 | AH[23:16] == 8'b1101_1110) begin
			dh_ZD[14:8] = 7'b000_0000;
      end else begin
			dh_ZD[14:8] = DD[6:0];
      end
   end


   always @(AH[12] or AH[13] or AH[14] or AH[15] or AH[16] or AH[17] or AH[18] or AH[19] or AH[20] or AH[21]
	 or AH[22] or AH[23] or r_w or D[15] or forceasif_ideintrq_DA8000) begin
      forceasif_ideintrq_DA8000_D = 1'b0;
      if ( (AH[23:12] == 12'b1101_1010_1000) & !r_w) begin
			forceasif_ideintrq_DA8000_D = D[15];
      end else begin
			forceasif_ideintrq_DA8000_D = forceasif_ideintrq_DA8000;
      end
   end


   always @(AH[12] or AH[13] or AH[14] or AH[15] or AH[16] or AH[17] or AH[18] or AH[19] or AH[20] or AH[21]
	 or AH[22] or AH[23] or r_w or D[15] or lastbitda8000 or intrq or
	 forceasif_ideintrq_DA8000 or int2_DA9000) begin
      int2_DA9000_D = 1'b0;
      if ( (AH[23:12] == 12'b1101_1010_1001) & !r_w & !D[15]) begin
			int2_DA9000_D = 1'b0;
      end else if (lastbitda8000 != (intrq | forceasif_ideintrq_DA8000)) begin
			int2_DA9000_D = 1'b1;
      end else begin
			int2_DA9000_D = int2_DA9000;
      end
   end


   always @(AH[12] or AH[13] or AH[14] or AH[15] or AH[16] or AH[17] or AH[18] or AH[19] or AH[20] or AH[21]
	 or AH[22] or AH[23] or r_w or D[15] or int2generationenable_DAA000) begin
      int2generationenable_DAA000_D = 1'b0;
      if ( (AH[23:12] == 12'b1101_1010_1010) & !r_w) begin
			int2generationenable_DAA000_D = D[15];
      end else begin
			int2generationenable_DAA000_D = int2generationenable_DAA000;
      end
   end
   assign int2 = int2_DA9000 & int2generationenable_DAA000;


   always @(intrq or forceasif_ideintrq_DA8000 or int2_DA9000 or
	 int2generationenable_DAA000 or AH[12] or AH[13] or AH[14] or AH[15] or AH[16] or
	 AH[17] or AH[18] or AH[19] or AH[20] or AH[21] or AH[22] or AH[23] or bit_from_sm or DD[7])
	 begin
      dh_ZD[15] = 1'b0;
      if (AH[23:12] == 12'b1101_1010_1000) begin
			dh_ZD[15] = intrq | forceasif_ideintrq_DA8000;
      end else if (AH[23:12] == 12'b1101_1010_1001) begin
			dh_ZD[15] = int2_DA9000;
      end else if (AH[23:12] == 12'b1101_1010_1010) begin
			dh_ZD[15] = int2generationenable_DAA000;
      end else if (AH[23:12] == 12'b1101_1010_1011) begin
			dh_ZD[15] = 1'b0;
      end else if (AH[23:16] == 8'b1101_1110) begin
			dh_ZD[15] = bit_from_sm;
      end else begin
			dh_ZD[15] = DD[7];
      end
   end


	//Optional IO
`ifdef OPTPIN_LED
	assign OPTPIN_I = Xled;
	assign OPTPIN_O = Xledpos;
	assign _configin = 1'b0;
`endif
`ifdef OPTPIN_CONFIG
	assign _configin = OPTPIN_I;
	assign OPTPIN_O = _configout;
`endif

endmodule
