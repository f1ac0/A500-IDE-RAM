// Inspired by original design and code of ide68k v425 by Mika Leinonen
// http://www.mkl211015.altervista.org/ide/ide68k.html
// Additional RAM idea inspired by Sector101
// https://blog.sector101.co.uk/2019/07/20/amiga-500-2mb-handwired-fastram-expansion/
// RAM autoconfig code adapted from Sukkopera
// https://github.com/SukkoPera/OpenAmiga500FastRamExpansion
//
// Schematic and PCB converted and merged in KiCAD, code converted to Verilog, merged, adapted, and everything tested by FLACO 2020
// This file Created 25-Apr-2020 10:08 AM
//
// ide68k license is unknown ; OpenAmiga500FastRamExpansion is CERN OHL 1.2
// 

module ide_ram_a500(
	input nas,
	input r_w,
	input nuds,
	input nlds,
	input nreset,
	input cpuclk7,
	input a23,
	input a22,
	input a21,
	input a20,
	input a19,
	input a18,
	input a17,
	input a16,
	input a15,
	input a14,
	input a13,
	input a12,
	input a6, //RAM
	input a5, //RAM
	input a4,
	input a3,
	input a2,
	input a1, //RAM
//	inout [15:0] d,
	inout d15,
	inout d14,
	inout d13,
	inout d12,
	inout d11,
	inout d10,
	inout d9,
	inout d8,
	inout d7,
	inout d6,
	inout d5,
	inout d4,
	inout d3,
	inout d2,
	inout d1,
	inout d0,
	input iordy_na,
	input ide_intrq,
	input ndaspin,
//	inout [15:0] dd,
	inout dd7,
	inout dd6,
	inout dd5,
	inout dd4,
	inout dd3,
	inout dd2,
	inout dd1,
	inout dd0,
	inout dd15,
	inout dd14,
	inout dd13,
	inout dd12,
	inout dd11,
	inout dd10,
	inout dd9,
	inout dd8,
	output nidereset,
//	output [2:0]da,
	output da2,
	output da1,
	output da0,
//	output [1:0]ncs,
	output ncs1,
	output ncs0,
	output niow,
	output nior,
	output ndtack,
	output ndtack2,
	output novr,
	output novr2,
	output nint2,
	output nint2_2,
	output led,
	output Xled,
	output Xledpos,
	output ram1ce, //RAM
	output ram2ce //RAM
	);	
		

//RAM
	wire ram_d_OE;
	wire [15:12] ram_d;
	ram_autoconfig ram(a21,a22,a23,
                 a1, a2, a3, a4, a5, a6,
                 a16,a17,a18,a19,a20,
                 ram_d[12],ram_d[13],ram_d[14],ram_d[15],
                 nas,nlds,nuds,cpuclk7,
                 nreset, ram1ce, ram2ce, ram_d_OE);

//IDE

   wire int2, override, dtack, snr0, snr1, snr2, n_reset_clocked, snr0_CLK,
	 snr1_CLK, snr2_CLK, n_reset_clocked_CLK, daspi, dasp_s, daspi_ACLR,
	 dasp_s_ACLR, daspi_CLK, dasp_s_CLK, ndtack_OE, ndtack2_OE, novr_OE,
	 novr2_OE, nint2_OE, nint2_2_OE, ledst1, ledst0,
	 forceasif_ideintrq_DA8000, lastbitda8000, int2_DA9000,
	 int2generationenable_DAA000, irq_synch0, intrq, d15_id_output,
	 stidreg2, stidreg1, stidreg0, ovr_range, nidereset_ACLR,
	 nidereset_CLK, da2_CLK, da2_ASET, da1_CLK, da1_ASET, da0_CLK,
	 da0_ASET, ncs0_CLK, ncs0_ASET, ncs1_CLK, ncs1_ASET,
	 not_nas_at_last_clk_rise, not_nas_at_last_clk_rise_CLK,
	 not_nas_at_last_clk_rise_ACLR, irq_synch0_CLK, irq_synch0_ACLR,
	 intrq_CLK, intrq_ACLR, forceasif_ideintrq_DA8000_CLK,
	 forceasif_ideintrq_DA8000_ACLR, lastbitda8000_CLK, lastbitda8000_ACLR,
	 int2_DA9000_CLK, int2_DA9000_ACLR, int2generationenable_DAA000_CLK,
	 int2generationenable_DAA000_ACLR, not_nas_at_last_clk_rise_D,
	 d15_id_output_D, intrq_D, irq_synch0_D, lastbitda8000_D, ncs0_D,
	 ncs1_D, da0_D, da1_D, da2_D, nidereset_D, dasp_s_D, daspi_D, snr2_D,
	 snr1_D, snr0_D, dd15_ZD, dd14_ZD, dd13_ZD, dd12_ZD, dd11_ZD, dd10_ZD,
	 dd9_ZD, dd8_ZD, d7_ZD, d6_ZD, d5_ZD, d4_ZD, d3_ZD, d2_ZD, d1_ZD,
	 d0_ZD, dd7_ZD, dd6_ZD, dd5_ZD, dd4_ZD, dd3_ZD, dd2_ZD, dd1_ZD, dd0_ZD,
	 nint2_2_ZD, nint2_ZD, novr2_ZD, novr_ZD, ndtack2_ZD, ndtack_ZD,
	 niow_bar, nior_bar, ncs1_D_bar, ncs0_D_bar, dd8_OE_ctrl, d0_OE_ctrl,
	 dd0_OE_ctrl, d8_OE_ctrl, stidreg0_ACLR_ctrl, stidreg0_CLK_ctrl,
	 ledst0_CLK_ctrl, ledst0_ACLR_ctrl;
   reg snr0_FB, snr1_FB, snr2_FB, n_reset_clocked_FB, daspi_FB, dasp_s_FB,
	 ledst1_D, ledst0_D, Xled_OE, bit_from_sm, stidreg2_D, stidreg1_D,
	 stidreg0_D, not_nas_at_last_clk_rise_FB, irq_synch0_FB,
	 forceasif_ideintrq_DA8000_FB, intrq_FB, lastbitda8000_FB,
	 int2_DA9000_FB, int2generationenable_DAA000_FB, stidreg0_FB,
	 stidreg1_FB, stidreg2_FB, d15_id_output_FB,
	 int2generationenable_DAA000_D, int2_DA9000_D,
	 forceasif_ideintrq_DA8000_D, ledst0_FB, ledst1_FB, ncs0_FB, ncs1_FB,
	 da0_FB, da1_FB, da2_FB, nidereset_FB, n_reset_clocked_D, d15_ZD,
	 d14_ZD, d13_ZD, d12_ZD, d11_ZD, d10_ZD, d9_ZD, d8_ZD, Xled_ZD;

   reg Xledpos_r;
	assign Xledpos = Xledpos_r;

   // initial {snr0_FB, snr1_FB, snr2_FB, n_reset_clocked_FB, daspi_FB,
   //       dasp_s_FB, not_nas_at_last_clk_rise_FB, irq_synch0_FB,
   //       forceasif_ideintrq_DA8000_FB, intrq_FB, lastbitda8000_FB,
   //       int2_DA9000_FB, int2generationenable_DAA000_FB, stidreg0_FB,
   //       stidreg1_FB, stidreg2_FB, ledst0_FB, ledst1_FB, ncs0_FB, ncs1_FB,
   //       da0_FB, da1_FB, da2_FB, nidereset_FB} = 24'h0;

   assign Xled = (Xled_OE) ? Xled_ZD : 1'bz;
   assign nint2_2 = (nint2_2_OE) ? nint2_2_ZD : 1'bz;
   assign nint2 = (nint2_OE) ? nint2_ZD : 1'bz;
   assign novr2 = (novr2_OE) ? novr2_ZD : 1'bz;
   assign novr = (novr_OE) ? novr_ZD : 1'bz;
   assign ndtack2 = (ndtack2_OE) ? ndtack2_ZD : 1'bz;
   assign ndtack = (ndtack_OE) ? ndtack_ZD : 1'bz;
   assign dd8 = (dd8_OE_ctrl) ? dd8_ZD : 1'bz;
   assign dd9 = (dd8_OE_ctrl) ? dd9_ZD : 1'bz;
   assign dd10 = (dd8_OE_ctrl) ? dd10_ZD : 1'bz;
   assign dd11 = (dd8_OE_ctrl) ? dd11_ZD : 1'bz;
   assign dd12 = (dd8_OE_ctrl) ? dd12_ZD : 1'bz;
   assign dd13 = (dd8_OE_ctrl) ? dd13_ZD : 1'bz;
   assign dd14 = (dd8_OE_ctrl) ? dd14_ZD : 1'bz;
   assign dd15 = (dd8_OE_ctrl) ? dd15_ZD : 1'bz;
   assign dd0 = (dd0_OE_ctrl) ? dd0_ZD : 1'bz;
   assign dd1 = (dd0_OE_ctrl) ? dd1_ZD : 1'bz;
   assign dd2 = (dd0_OE_ctrl) ? dd2_ZD : 1'bz;
   assign dd3 = (dd0_OE_ctrl) ? dd3_ZD : 1'bz;
   assign dd4 = (dd0_OE_ctrl) ? dd4_ZD : 1'bz;
   assign dd5 = (dd0_OE_ctrl) ? dd5_ZD : 1'bz;
   assign dd6 = (dd0_OE_ctrl) ? dd6_ZD : 1'bz;
   assign dd7 = (dd0_OE_ctrl) ? dd7_ZD : 1'bz;
   assign d0 = (d0_OE_ctrl) ? d0_ZD : 1'bz;
   assign d1 = (d0_OE_ctrl) ? d1_ZD : 1'bz;
   assign d2 = (d0_OE_ctrl) ? d2_ZD : 1'bz;
   assign d3 = (d0_OE_ctrl) ? d3_ZD : 1'bz;
   assign d4 = (d0_OE_ctrl) ? d4_ZD : 1'bz;
   assign d5 = (d0_OE_ctrl) ? d5_ZD : 1'bz;
   assign d6 = (d0_OE_ctrl) ? d6_ZD : 1'bz;
   assign d7 = (d0_OE_ctrl) ? d7_ZD : 1'bz;
   assign d8 = (d8_OE_ctrl) ? d8_ZD : 1'bz;
   assign d9 = (d8_OE_ctrl) ? d9_ZD : 1'bz;
   assign d10 = (d8_OE_ctrl) ? d10_ZD : 1'bz;
   assign d11 = (d8_OE_ctrl) ? d11_ZD : 1'bz;
   assign d12 = (d8_OE_ctrl) ? d12_ZD : (ram_d_OE ? ram_d[12] : 1'bz);
   assign d13 = (d8_OE_ctrl) ? d13_ZD : (ram_d_OE ? ram_d[13] : 1'bz);
   assign d14 = (d8_OE_ctrl) ? d14_ZD : (ram_d_OE ? ram_d[14] : 1'bz);
   assign d15 = (d8_OE_ctrl) ? d15_ZD : (ram_d_OE ? ram_d[15] : 1'bz);


   assign snr0 = snr0_FB;
   always @(posedge snr0_CLK)
      snr0_FB <= snr0_D;

   assign snr1 = snr1_FB;
   always @(posedge snr1_CLK)
      snr1_FB <= snr1_D;

   assign snr2 = snr2_FB;
   always @(posedge snr2_CLK)
      snr2_FB <= snr2_D;

   assign n_reset_clocked = n_reset_clocked_FB;
   always @(posedge n_reset_clocked_CLK)
      n_reset_clocked_FB <= n_reset_clocked_D;

   assign daspi = daspi_FB;
   always @(posedge daspi_CLK or posedge daspi_ACLR)
      if (daspi_ACLR)
	 daspi_FB <= 1'h0;
      else
	 daspi_FB <= daspi_D;

   assign dasp_s = dasp_s_FB;
   always @(posedge dasp_s_CLK or posedge dasp_s_ACLR)
      if (dasp_s_ACLR)
	 dasp_s_FB <= 1'h0;
      else
	 dasp_s_FB <= dasp_s_D;

   assign nidereset = nidereset_FB;
   always @(posedge nidereset_CLK or posedge nidereset_ACLR)
      if (nidereset_ACLR)
	 nidereset_FB <= 1'h0;
      else
	 nidereset_FB <= nidereset_D;

   assign da2 = da2_FB;
   always @(posedge da2_CLK or posedge da2_ASET)
      if (da2_ASET)
	 da2_FB <= 1'h1;
      else
	 da2_FB <= da2_D;

   assign da1 = da1_FB;
   always @(posedge da1_CLK or posedge da1_ASET)
      if (da1_ASET)
	 da1_FB <= 1'h1;
      else
	 da1_FB <= da1_D;

   assign da0 = da0_FB;
   always @(posedge da0_CLK or posedge da0_ASET)
      if (da0_ASET)
	 da0_FB <= 1'h1;
      else
	 da0_FB <= da0_D;

   assign ncs1 = ncs1_FB;
   always @(posedge ncs1_CLK or posedge ncs1_ASET)
      if (ncs1_ASET)
	 ncs1_FB <= 1'h1;
      else
	 ncs1_FB <= ncs1_D;

   assign ncs0 = ncs0_FB;
   always @(posedge ncs0_CLK or posedge ncs0_ASET)
      if (ncs0_ASET)
	 ncs0_FB <= 1'h1;
      else
	 ncs0_FB <= ncs0_D;

   assign {ledst1, ledst0} = {ledst1_FB, ledst0_FB};
   always @(posedge ledst0_CLK_ctrl or posedge ledst0_ACLR_ctrl)
      if (ledst0_ACLR_ctrl)
	 {ledst1_FB, ledst0_FB} <= 2'h0;
      else
	 {ledst1_FB, ledst0_FB} <= {ledst1_D, ledst0_D};

   assign forceasif_ideintrq_DA8000 = forceasif_ideintrq_DA8000_FB;
   always @(posedge forceasif_ideintrq_DA8000_CLK or posedge
	 forceasif_ideintrq_DA8000_ACLR)
      if (forceasif_ideintrq_DA8000_ACLR)
	 forceasif_ideintrq_DA8000_FB <= 1'h0;
      else
	 forceasif_ideintrq_DA8000_FB <= forceasif_ideintrq_DA8000_D;

   assign lastbitda8000 = lastbitda8000_FB;
   always @(posedge lastbitda8000_CLK or posedge lastbitda8000_ACLR)
      if (lastbitda8000_ACLR)
	 lastbitda8000_FB <= 1'h0;
      else
	 lastbitda8000_FB <= lastbitda8000_D;

   assign int2_DA9000 = int2_DA9000_FB;
   always @(posedge int2_DA9000_CLK or posedge int2_DA9000_ACLR)
      if (int2_DA9000_ACLR)
	 int2_DA9000_FB <= 1'h0;
      else
	 int2_DA9000_FB <= int2_DA9000_D;

   assign int2generationenable_DAA000 = int2generationenable_DAA000_FB;
   always @(posedge int2generationenable_DAA000_CLK or posedge
	 int2generationenable_DAA000_ACLR)
      if (int2generationenable_DAA000_ACLR)
	 int2generationenable_DAA000_FB <= 1'h0;
      else
	 int2generationenable_DAA000_FB <= int2generationenable_DAA000_D;

   assign irq_synch0 = irq_synch0_FB;
   always @(posedge irq_synch0_CLK or posedge irq_synch0_ACLR)
      if (irq_synch0_ACLR)
	 irq_synch0_FB <= 1'h0;
      else
	 irq_synch0_FB <= irq_synch0_D;

   assign intrq = intrq_FB;
   always @(posedge intrq_CLK or posedge intrq_ACLR)
      if (intrq_ACLR)
	 intrq_FB <= 1'h0;
      else
	 intrq_FB <= intrq_D;

   assign {stidreg2, stidreg1, stidreg0} = {stidreg2_FB, stidreg1_FB,
	 stidreg0_FB};
   always @(posedge stidreg0_CLK_ctrl or posedge stidreg0_ACLR_ctrl)
      if (stidreg0_ACLR_ctrl)
	 {stidreg2_FB, stidreg1_FB, stidreg0_FB} <= 3'h0;
      else
	 {stidreg2_FB, stidreg1_FB, stidreg0_FB} <= {stidreg2_D, stidreg1_D,
	       stidreg0_D};

   assign not_nas_at_last_clk_rise = not_nas_at_last_clk_rise_FB;
   always @(posedge not_nas_at_last_clk_rise_CLK or posedge
	 not_nas_at_last_clk_rise_ACLR)
      if (not_nas_at_last_clk_rise_ACLR)
	 not_nas_at_last_clk_rise_FB <= 1'h0;
      else
	 not_nas_at_last_clk_rise_FB <= not_nas_at_last_clk_rise_D;

// Start of original equations
   assign snr0_CLK = cpuclk7;
   assign snr1_CLK = cpuclk7;
   assign snr2_CLK = cpuclk7;
   assign n_reset_clocked_CLK = cpuclk7;
   assign snr0_D = nreset;
   assign snr1_D = snr0_FB;
   assign snr2_D = snr1_FB;


   always @(snr1_FB or snr2_FB or n_reset_clocked_FB) begin
      n_reset_clocked_D = 1'b0;
      if (snr1_FB == snr2_FB) begin
	 n_reset_clocked_D = snr2_FB;
      end else begin
	 n_reset_clocked_D = n_reset_clocked_FB;
      end
   end
   assign daspi_ACLR = !n_reset_clocked_FB;
   assign dasp_s_ACLR = !n_reset_clocked_FB;
   assign daspi_CLK = cpuclk7;
   assign dasp_s_CLK = cpuclk7;
   assign daspi_D = !ndaspin;
   assign dasp_s_D = daspi_FB;
   assign ndtack_ZD = 1'b0;
   assign ndtack_OE = dtack;
   assign ndtack2_ZD = 1'b0;
   assign ndtack2_OE = dtack;
   assign novr_ZD = 1'b0;
   assign novr_OE = override;
   assign novr2_ZD = 1'b0;
   assign novr2_OE = override;
   assign nint2_ZD = 1'b0;
   assign nint2_OE = int2;
   assign nint2_2_ZD = 1'b0;
   assign nint2_2_OE = int2;
   assign led = !dasp_s_FB;
   assign ledst0_ACLR_ctrl = !n_reset_clocked_FB;
   assign ledst0_CLK_ctrl = cpuclk7;


   always @(ledst0_FB or ledst1_FB or dasp_s_FB) begin
      {Xled_ZD, Xledpos_r, Xled_OE, ledst1_D, ledst0_D} = 5'b0_0000;
      case ({ledst1_FB, ledst0_FB})
      2'b00: begin
	    Xled_ZD = 1'b0;
	    Xledpos_r = 1'b1;
	    Xled_OE = 1'b1;
	    if (dasp_s_FB) begin
	       {ledst1_D, ledst0_D} = 2'b00;
	    end else begin
	       {ledst1_D, ledst0_D} = 2'b01;
	    end
	 end
      2'b01: begin
	    Xled_ZD = 1'b1;
	    Xledpos_r = 1'b1;
	    Xled_OE = 1'b1;
	    {ledst1_D, ledst0_D} = 2'b10;
	 end
      2'b10: begin
	    Xled_ZD = 1'b1;
	    Xledpos_r = 1'b1;
	    Xled_OE = 1'b0;
	    {ledst1_D, ledst0_D} = 2'b11;
	 end
      2'b11: begin
	    Xled_ZD = 1'b1;
	    Xledpos_r = 1'b0;
	    Xled_OE = 1'b0;
	    if (dasp_s_FB) begin
	       {ledst1_D, ledst0_D} = 2'b00;
	    end else begin
	       {ledst1_D, ledst0_D} = 2'b11;
	    end
	 end
      endcase
   end
   assign stidreg0_CLK_ctrl = nas;
   assign stidreg0_ACLR_ctrl = !n_reset_clocked_FB;


   always @(stidreg0_FB or stidreg1_FB or stidreg2_FB or a3 or a16 or a17 or
	 a18 or a19 or a20 or a21 or a22 or a23 or r_w) begin
      {bit_from_sm, stidreg2_D, stidreg1_D, stidreg0_D} = 4'b0000;
      case ({stidreg2_FB, stidreg1_FB, stidreg0_FB})
      3'b110: begin
	    bit_from_sm = 1'b1;
	    {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b000;
	 end
      3'b111: begin
	    bit_from_sm = 1'b1;
	    {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b000;
	 end
      3'b000: begin
	    bit_from_sm = 1'b1;
	    if ({a23, a22, a21, a20, a19, a18, a17, a16} == 8'b1101_1110 & a3
		  == 1'b0) begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b001;
	    end else begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b000;
	    end
	 end
      3'b001: begin
	    bit_from_sm = 1'b1;
	    if ({a23, a22, a21, a20, a19, a18, a17, a16} == 8'b1101_1110 & r_w
		  == 1'b0) begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b010;
	    end else begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b001;
	    end
	 end
      3'b010: begin
	    bit_from_sm = 1'b1;
	    if ({a23, a22, a21, a20, a19, a18, a17, a16} == 8'b1101_1110 & r_w
		  == 1'b1) begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b011;
	    end else begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b010;
	    end
	 end
      3'b011: begin
	    bit_from_sm = 1'b1;
	    if ({a23, a22, a21, a20, a19, a18, a17, a16} == 8'b1101_1110 & r_w
		  == 1'b0) begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b010;
	    end else if ({a23, a22, a21, a20, a19, a18, a17, a16} ==
		  8'b1101_1110 & r_w == 1'b1) begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b100;
	    end else begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b011;
	    end
	 end
      3'b100: begin
	    bit_from_sm = 1'b0;
	    if ({a23, a22, a21, a20, a19, a18, a17, a16} == 8'b1101_1110 & r_w
		  == 1'b0) begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b010;
	    end else if ({a23, a22, a21, a20, a19, a18, a17, a16} ==
		  8'b1101_1110 & r_w == 1'b1) begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b101;
	    end else begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b100;
	    end
	 end
      3'b101: begin
	    bit_from_sm = 1'b1;
	    if ({a23, a22, a21, a20, a19, a18, a17, a16} == 8'b1101_1110 & r_w
		  == 1'b0) begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b010;
	    end else begin
	       {stidreg2_D, stidreg1_D, stidreg0_D} = 3'b101;
	    end
	 end
      endcase
   end
   assign ovr_range = {a23, a22, a21, a20, a19, a18, a17, a16} == 8'b1101_1110
	 | {a23, a22, a21, a20, a19, a18, a17, a16} == 8'b1101_1010 | {a23,
	 a22, a21, a20, a19, a18, a17, a16} == 8'b1101_1001 | {a23, a22, a21,
	 a20, a19, a18, a17, a16} == 8'b1101_1011;
   assign override = ovr_range;
   assign dtack = nas == 1'b0 & ovr_range;
   assign nidereset_ACLR = !n_reset_clocked_FB;
   assign nidereset_CLK = cpuclk7;
   assign nidereset_D = 1'b1;
   assign da2_D = a4;
   assign da2_CLK = !nas;
   assign da2_ASET = !n_reset_clocked_FB;
   assign da1_D = a3;
   assign da1_CLK = !nas;
   assign da1_ASET = !n_reset_clocked_FB;
   assign da0_D = a2;
   assign da0_CLK = !nas;
   assign da0_ASET = !n_reset_clocked_FB;
   assign ncs0_CLK = !nas;
   assign ncs0_ASET = !n_reset_clocked_FB;
   assign ncs1_CLK = !nas;
   assign ncs1_ASET = !n_reset_clocked_FB;
   assign ncs0_D_bar = {a23, a22, a21, a20, a19, a18, a17, a16, a15, a14, a13,
	 a12} == 12'b1101_1010_0000 | {a23, a22, a21, a20, a19, a18, a17, a16,
	 a15, a14, a13, a12} == 12'b1101_1010_0010;
   assign ncs1_D_bar = {a23, a22, a21, a20, a19, a18, a17, a16, a15, a14, a13,
	 a12} == 12'b1101_1010_0001 | {a23, a22, a21, a20, a19, a18, a17, a16,
	 a15, a14, a13, a12} == 12'b1101_1010_0011;
   assign not_nas_at_last_clk_rise_CLK = cpuclk7;
   assign not_nas_at_last_clk_rise_ACLR = !n_reset_clocked_FB;
   assign not_nas_at_last_clk_rise_D = !nas;
   assign nior_bar = not_nas_at_last_clk_rise_FB & nas == 1'b0 & r_w == 1'b1 &
	 {a23, a22, a21, a20, a19, a18, a17, a16, a15, a14} ==
	 10'b11_0110_1000;
   assign niow_bar = not_nas_at_last_clk_rise_FB & nas == 1'b0 & r_w == 1'b0 &
	 {a23, a22, a21, a20, a19, a18, a17, a16, a15, a14} ==
	 10'b11_0110_1000;
   assign d8_OE_ctrl = r_w == 1'b1 & nuds == 1'b0 & nas == 1'b0 & ({a23, a22,
	 a21, a20, a19, a18, a17, a16, a15, a14} == 10'b11_0110_1000 | {a23,
	 a22, a21, a20, a19, a18, a17, a16, a15, a14} == 10'b11_0110_1010 |
	 {a23, a22, a21, a20, a19, a18, a17, a16} == 8'b1101_1110);
   assign {dd7_ZD, dd6_ZD, dd5_ZD, dd4_ZD, dd3_ZD, dd2_ZD, dd1_ZD, dd0_ZD} =
	 {d15, d14, d13, d12, d11, d10, d9, d8};
   assign dd0_OE_ctrl = r_w == 1'b0 & nas == 1'b0 & {a23, a22, a21, a20, a19,
	 a18, a17, a16, a15, a14} == 10'b11_0110_1000;
   assign {d7_ZD, d6_ZD, d5_ZD, d4_ZD, d3_ZD, d2_ZD, d1_ZD, d0_ZD} = {dd15,
	 dd14, dd13, dd12, dd11, dd10, dd9, dd8};
   assign d0_OE_ctrl = r_w == 1'b1 & nlds == 1'b0 & nas == 1'b0 & ({a23, a22,
	 a21, a20, a19, a18, a17, a16, a15, a14, a13, a12} ==
	 12'b1101_1010_0010 | {a23, a22, a21, a20, a19, a18, a17, a16, a15,
	 a14, a13, a12} == 12'b1101_1010_0011);
   assign {dd15_ZD, dd14_ZD, dd13_ZD, dd12_ZD, dd11_ZD, dd10_ZD, dd9_ZD,
	 dd8_ZD} = {d7, d6, d5, d4, d3, d2, d1, d0};
   assign dd8_OE_ctrl = r_w == 1'b0 & nas == 1'b0 & ({a23, a22, a21, a20, a19,
	 a18, a17, a16, a15, a14, a13, a12} == 12'b1101_1010_0010 | {a23, a22,
	 a21, a20, a19, a18, a17, a16, a15, a14, a13, a12} ==
	 12'b1101_1010_0011);
   assign irq_synch0_CLK = cpuclk7;
   assign irq_synch0_ACLR = !n_reset_clocked_FB;
   assign intrq_CLK = cpuclk7;
   assign intrq_ACLR = !n_reset_clocked_FB;
   assign irq_synch0_D = ide_intrq;
   assign intrq_D = irq_synch0_FB;


   always @(a12 or a13 or a14 or a15 or a16 or a17 or a18 or a19 or a20 or a21
	 or a22 or a23 or dd0 or dd1 or dd2 or dd3 or dd4 or dd5 or dd6) begin
      {d14_ZD, d13_ZD, d12_ZD, d11_ZD, d10_ZD, d9_ZD, d8_ZD} = 7'b000_0000;
      if ({a23, a22, a21, a20, a19, a18, a17, a16, a15, a14, a13, a12} ==
	    12'b1101_1010_1000 | {a23, a22, a21, a20, a19, a18, a17, a16, a15,
	    a14, a13, a12} == 12'b1101_1010_1001 | {a23, a22, a21, a20, a19,
	    a18, a17, a16, a15, a14, a13, a12} == 12'b1101_1010_1010 | {a23,
	    a22, a21, a20, a19, a18, a17, a16, a15, a14, a13, a12} ==
	    12'b1101_1010_1011 | {a23, a22, a21, a20, a19, a18, a17, a16} ==
	    8'b1101_1110) begin
	 {d14_ZD, d13_ZD, d12_ZD, d11_ZD, d10_ZD, d9_ZD, d8_ZD} = 7'b000_0000;
      end else begin
	 {d14_ZD, d13_ZD, d12_ZD, d11_ZD, d10_ZD, d9_ZD, d8_ZD} = {dd6, dd5,
	       dd4, dd3, dd2, dd1, dd0};
      end
   end
   assign forceasif_ideintrq_DA8000_CLK = nas;
   assign forceasif_ideintrq_DA8000_ACLR = !n_reset_clocked_FB;


   always @(a12 or a13 or a14 or a15 or a16 or a17 or a18 or a19 or a20 or a21
	 or a22 or a23 or r_w or d15 or forceasif_ideintrq_DA8000_FB) begin
      forceasif_ideintrq_DA8000_D = 1'b0;
      if ({a23, a22, a21, a20, a19, a18, a17, a16, a15, a14, a13, a12} ==
	    12'b1101_1010_1000 & r_w == 1'b0) begin
	 forceasif_ideintrq_DA8000_D = d15;
      end else begin
	 forceasif_ideintrq_DA8000_D = forceasif_ideintrq_DA8000_FB;
      end
   end
   assign lastbitda8000_CLK = nas;
   assign lastbitda8000_ACLR = !n_reset_clocked_FB;
   assign lastbitda8000_D = intrq_FB | forceasif_ideintrq_DA8000_FB;
   assign int2_DA9000_CLK = nas;
   assign int2_DA9000_ACLR = !n_reset_clocked_FB;


   always @(a12 or a13 or a14 or a15 or a16 or a17 or a18 or a19 or a20 or a21
	 or a22 or a23 or r_w or d15 or lastbitda8000_FB or intrq_FB or
	 forceasif_ideintrq_DA8000_FB or int2_DA9000_FB) begin
      int2_DA9000_D = 1'b0;
      if ({a23, a22, a21, a20, a19, a18, a17, a16, a15, a14, a13, a12} ==
	    12'b1101_1010_1001 & r_w == 1'b0 & d15 == 1'b0) begin
	 int2_DA9000_D = 1'b0;
      end else if (lastbitda8000_FB != (intrq_FB |
	    forceasif_ideintrq_DA8000_FB)) begin
	 int2_DA9000_D = 1'b1;
      end else begin
	 int2_DA9000_D = int2_DA9000_FB;
      end
   end
   assign int2generationenable_DAA000_CLK = nas;
   assign int2generationenable_DAA000_ACLR = !n_reset_clocked_FB;


   always @(a12 or a13 or a14 or a15 or a16 or a17 or a18 or a19 or a20 or a21
	 or a22 or a23 or r_w or d15 or int2generationenable_DAA000_FB) begin
      int2generationenable_DAA000_D = 1'b0;
      if ({a23, a22, a21, a20, a19, a18, a17, a16, a15, a14, a13, a12} ==
	    12'b1101_1010_1010 & r_w == 1'b0) begin
	 int2generationenable_DAA000_D = d15;
      end else begin
	 int2generationenable_DAA000_D = int2generationenable_DAA000_FB;
      end
   end
   assign int2 = int2_DA9000_FB & int2generationenable_DAA000_FB;


   always @(intrq_FB or forceasif_ideintrq_DA8000_FB or int2_DA9000_FB or
	 int2generationenable_DAA000_FB or a12 or a13 or a14 or a15 or a16 or
	 a17 or a18 or a19 or a20 or a21 or a22 or a23 or bit_from_sm or dd7)
	 begin
      d15_ZD = 1'b0;
      if ({a23, a22, a21, a20, a19, a18, a17, a16, a15, a14, a13, a12} ==
	    12'b1101_1010_1000) begin
	 d15_ZD = intrq_FB | forceasif_ideintrq_DA8000_FB;
      end else if ({a23, a22, a21, a20, a19, a18, a17, a16, a15, a14, a13, a12}
	    == 12'b1101_1010_1001) begin
	 d15_ZD = int2_DA9000_FB;
      end else if ({a23, a22, a21, a20, a19, a18, a17, a16, a15, a14, a13, a12}
	    == 12'b1101_1010_1010) begin
	 d15_ZD = int2generationenable_DAA000_FB;
      end else if ({a23, a22, a21, a20, a19, a18, a17, a16, a15, a14, a13, a12}
	    == 12'b1101_1010_1011) begin
	 d15_ZD = 1'b0;
      end else if ({a23, a22, a21, a20, a19, a18, a17, a16} == 8'b1101_1110)
	    begin
	 d15_ZD = bit_from_sm;
      end else begin
	 d15_ZD = dd7;
      end
   end


// Assignments added to explicitly combine the effects of 
// multiple drivers and negative assignments in the source
   assign ncs1_D = !ncs1_D_bar;
   assign ncs0_D = !ncs0_D_bar;
   assign nior = !nior_bar;
   assign niow = !niow_bar;
		
endmodule
