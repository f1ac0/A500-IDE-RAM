// Inspired by original design and code of ide68k v425 by Mika Leinonen
// now offline :http://www.mkl211015.altervista.org/ide/ide68k.html
// https://web.archive.org/web/20200221025111/http://www.mkl211015.altervista.org/ide/ide68k.html
//
// Schematic and PCB converted and merged in KiCAD, code converted to Verilog, merged, adapted, and everything tested by FLACO 2020
// This file Created 25-Apr-2020 10:08 AM
//
// ide68k license is unknown
// 

module ide(
//68000 bus
	input _AS,
	input R_W,
	input _UDS,
	input _LDS,
	input _RESET,
	input CLK,
	input [23:12] AH,
	input [4:2] AL, //6,5,1 added for RAM
	input [15:0] DIN,
	output [15:0] DOUT,
	output D8_OE,
	output D0_OE,
	output IDERANGE,
	output _INT2,

//IDE
//	input IORDY,
	input INTRQ,
	input _ACTIVE,
	input [15:0] DDIN,
	output [15:0] DDOUT,
	output DD8_OE,
	output DD0_OE,
	output reg _DRESET,
	output reg [2:0] DA,
	output reg [1:0] _CS,
	output _DIOW,
	output _DIOR,

//LEDs
	output _LED,
	output reg Xled_OE,
	output reg Xled_ZD,
	output reg Xledpos
	);

	wire [7:0] dl_ZD;
	reg [15:8] dh_ZD;
	assign DOUT[15:0] = {dh_ZD[15:8], dl_ZD[7:0]};
	
	reg [2:0] snr;
	reg [2:0] stidreg;
	reg [2:0] stidreg_D;
   reg n_reset_clocked, daspi, dasp_s,
	 ledst1_D, ledst0_D, bit_from_sm,
	 not_nas_at_last_clk_rise, irq_synch0,
	 forceasif_ideintrq_DA8000, irq_synch1, lastbitda8000,
	 int2_DA9000, int2generationenable_DAA000,
	 int2generationenable_DAA000_D, int2_DA9000_D,
	 forceasif_ideintrq_DA8000_D, ledst0, ledst1,
	 n_reset_clocked_D;

   // initial {snr[0], snr[1], snr[2], n_reset_clocked, daspi,
   //       dasp_s, not_nas_at_last_clk_rise, irq_synch0,
   //       forceasif_ideintrq_DA8000, irq_synch1, lastbitda8000,
   //       int2_DA9000, int2generationenable_DAA000, stidreg[0],
   //       stidreg[1], stidreg[2], ledst0, ledst1, _CS[0], _CS[1],
   //       DA[0], DA[1], DA[2], _DRESET} = 24'h0;

//clocked signals
	always @(posedge CLK) begin
		snr[0] <= _RESET;
		snr[1] <= snr[0];
		snr[2] <= snr[1];
      n_reset_clocked <= n_reset_clocked_D;
	end

	always @(posedge CLK or negedge n_reset_clocked)
		if (!n_reset_clocked) begin
			daspi <= 1'h0;
			dasp_s <= 1'h0;
			_DRESET <= 1'h0;
			{ledst1, ledst0} <= 2'h0;
			irq_synch0 <= 1'h0;
			irq_synch1 <= 1'h0;
			not_nas_at_last_clk_rise <= 1'h0;
		end else begin
			daspi <= !_ACTIVE;
			dasp_s <= daspi;
			_DRESET <= 1'b1;
			{ledst1, ledst0} <= {ledst1_D, ledst0_D};
			irq_synch0 <= INTRQ;
			irq_synch1 <= irq_synch0;
			not_nas_at_last_clk_rise <= !_AS;
		end

	always @(negedge _AS or negedge n_reset_clocked)
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
 
	always @(posedge _AS or negedge n_reset_clocked)
		if (!n_reset_clocked) begin
			forceasif_ideintrq_DA8000 <= 1'h0;
			lastbitda8000 <= 1'h0;
			int2_DA9000 <= 1'h0;
			int2generationenable_DAA000 <= 1'h0;
			stidreg[2:0] <= 3'h0;
		end else begin
			forceasif_ideintrq_DA8000 <= forceasif_ideintrq_DA8000_D;
			lastbitda8000 <= irq_synch1 | forceasif_ideintrq_DA8000;
			int2_DA9000 <= int2_DA9000_D;
			int2generationenable_DAA000 <= int2generationenable_DAA000_D;
			stidreg[2:0] <= stidreg_D[2:0];
		end


// Start of original equations

//reset line filter
   always @(snr[1] or snr[2] or n_reset_clocked) begin
      n_reset_clocked_D = 1'b0;
      if (snr[1] == snr[2]) begin
	 n_reset_clocked_D = snr[2];
      end else begin
	 n_reset_clocked_D = n_reset_clocked;
      end
   end
	
//leds and misc
//Secondary led outputs need external series resistor
   assign _LED = !dasp_s;
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

//HW identification state machine is modeled after hddmem a500 project at aminet hard/hack
	always @(stidreg[0] or stidreg[1] or stidreg[2] or AL[3] or AH[16] or AH[17] or AH[18] or AH[19] or AH[20] or AH[21] or AH[22] or AH[23] or R_W) begin
		{bit_from_sm, stidreg_D[2:0]} = 4'b0000;
		case (stidreg[2:0])
			//state st6invalid: unused state
			3'b110: begin
				bit_from_sm = 1'b1;
				stidreg_D[2:0] = 3'b000;
				end
			//state st7invalid: unused state
			3'b111: begin
				bit_from_sm = 1'b1;
				stidreg_D[2:0] = 3'b000;
				end
			//state after reset
			3'b000: begin
				bit_from_sm = 1'b1;
				if (AH[23:16] == 8'hDE & !AL[3]) begin
					stidreg_D[2:0] = 3'b001;
				end else begin
					stidreg_D[2:0] = 3'b000;
				end
				end
			//state after first (read or) write at $dexxxx with a3=0
			3'b001: begin
				bit_from_sm = 1'b1;
				if (AH[23:16] == 8'hDE & !R_W) begin
					stidreg_D[2:0] = 3'b010;
				end else begin
					stidreg_D[2:0] = 3'b001;
				end
				end
			//state after two write to $dexxxx, output d15 = 1
			3'b010: begin
				bit_from_sm = 1'b1;
				if (AH[23:16] == 8'hDE & R_W) begin
					stidreg_D[2:0] = 3'b011;
				end else begin
					stidreg_D[2:0] = 3'b010;
				end
			end
			//state after first read $dexxxx, output d15 = 1
			3'b011: begin
				bit_from_sm = 1'b1;
				if (AH[23:16] == 8'hDE & !R_W) begin
					stidreg_D[2:0] = 3'b010;
				end else if (AH[23:16] == 8'hDE & R_W) begin
					stidreg_D[2:0] = 3'b100;
				end else begin
					stidreg_D[2:0] = 3'b011;
				end
				end
			//state after two read $dexxxx, output d15 from sm = 0
			3'b100: begin
				bit_from_sm = 1'b0;
				if (AH[23:16] == 8'hDE & !R_W) begin
					stidreg_D[2:0] = 3'b010;
				end else if (AH[23:16] == 8'hDE & R_W) begin
					stidreg_D[2:0] = 3'b101;
				end else begin
					stidreg_D[2:0] = 3'b100;
				end
				end
			//state after three read $dexxxx, output d15 = 1
			3'b101: begin
				bit_from_sm = 1'b1;
				if (AH[23:16] == 8'hDE & !R_W) begin
					stidreg_D[2:0] = 3'b010;
				end else begin
					stidreg_D[2:0] = 3'b101;
				end
				end
		endcase
	end
	
	//override = 1 causes amiga /ovr pulled low (open drain output)
   assign IDERANGE = AH[23:16] == 8'hDE | AH[23:16] == 8'hDA | AH[23:16] == 8'hD9 | AH[23:16] == 8'hDB;
   assign _DIOR = ! ( not_nas_at_last_clk_rise & !_AS & R_W & AH[23:14] == 10'b11_0110_1000 ); //DA0000-DA3FFF
   assign _DIOW = ! ( not_nas_at_last_clk_rise & !_AS & !R_W & AH[23:14] == 10'b11_0110_1000 ); //DA0000-DA3FFF
	//output enable to cpu upper byte from/via cpld
	//output cpu highbyte: read from gayleregs or DExxxx or cpld-buffered ide data
	assign D8_OE = R_W & !_UDS & !_AS & (AH[23:14] == 10'b11_0110_1000 | AH[23:14] == 10'b11_0110_1010 |
	 AH[23:16] == 8'hDE); //DA0000-DA3FFF //DA8000-DABFFF
	//output enable buffer via cpld to ide data bus dd7..0
	assign DDOUT[7:0] = DIN[15:8];
   assign DD0_OE = !R_W & !_AS & AH[23:14] == 10'b11_0110_1000; //DA0000-DA3FFF
	//when cpld is used to buffer ide data 15..8 / clockport data
   assign dl_ZD[7:0] = DDIN[15:8];
   assign D0_OE = R_W & !_LDS & !_AS & (AH[23:12] == 12'hDA2 | AH[23:12] == 12'hDA3);
   assign DDOUT[15:8] = DIN[7:0];
   assign DD8_OE = !R_W & !_AS & (AH[23:12] == 12'hDA2 | AH[23:12] == 12'hDA3);

//emulate registers of Gayle
	//d14..d8 read
	//DA8000 
	//d14 CC det status credit card (memory) present if d14 = '1'
	//d13 BVD2/DA status Battery voltage detect 2 / Digital audio
	//d12 BVD1/SC status Battery voltage detect 1 / Credit card (internal) status change
	//d11 WR enable; this bit is high when the credit card is write enabled,
	//d10 BSY/IRQ Credit card busy/Interrupt request
	//Bit 9 Enable for the digital audio
	//Bit 8 Allows the software to disable the credit card interface ('1') 
	//DA9000 DAA000 .......
   always @(AH[12] or AH[13] or AH[14] or AH[15] or AH[16] or AH[17] or AH[18] or AH[19] or AH[20] or AH[21]
	 or AH[22] or AH[23] or DDIN[0] or DDIN[1] or DDIN[2] or DDIN[3] or DDIN[4] or DDIN[5] or DDIN[6]) begin
      dh_ZD[14:8] = 7'b000_0000;
      if (AH[23:12] == 12'hDA8 | AH[23:12] == 12'hDA9 | AH[23:12] == 12'hDAA | AH[23:12] == 12'hDAB | AH[23:16] == 8'hDE) begin
			dh_ZD[14:8] = 7'b000_0000;
      end else begin
			dh_ZD[14:8] = DDIN[6:0];
      end
   end

	//cpu d15 IDE related / DExxxx

	//da8000
	//Represents an external line. Reading this allows the software to determine the current state of the line.
	//Writing a value of 1 to this bit allows the software to force me to behave as if the line is asserted (including returning a '1' when this register is read)
	always @(AH[12] or AH[13] or AH[14] or AH[15] or AH[16] or AH[17] or AH[18] or AH[19] or AH[20] or AH[21]
	 or AH[22] or AH[23] or R_W or DIN[15] or forceasif_ideintrq_DA8000) begin
		forceasif_ideintrq_DA8000_D = 1'b0;
		if ( (AH[23:12] == 12'hDA8) & !R_W) begin //12'b1101_1010_1000
			forceasif_ideintrq_DA8000_D = DIN[15];
		end else begin
			forceasif_ideintrq_DA8000_D = forceasif_ideintrq_DA8000;
		end
	end

	//da9000
	//Is the same signal as at address $DA8000, but the register at da9000 tells you when this bit has changed value
	//The bit remains high (and the interrupt line remains active) until a '0' is written to that bit
	//Writing a '1' will cause the bit to be unchanged
	always @(AH[12] or AH[13] or AH[14] or AH[15] or AH[16] or AH[17] or AH[18] or AH[19] or AH[20] or AH[21]
	 or AH[22] or AH[23] or R_W or DIN[15] or lastbitda8000 or irq_synch1 or
	 forceasif_ideintrq_DA8000 or int2_DA9000) begin
		int2_DA9000_D = 1'b0;
		if ( (AH[23:12] == 12'hDA9) & !R_W & !DIN[15]) begin //12'b1101_1010_1001
			int2_DA9000_D = 1'b0;
		end else if (lastbitda8000 != (irq_synch1 | forceasif_ideintrq_DA8000)) begin
			int2_DA9000_D = 1'b1;
		end else begin
			int2_DA9000_D = int2_DA9000;
		end
	end

	//daa000
	//Enables generation of an int2 on status change of the interrupt line of the IDE interface
	always @(AH[12] or AH[13] or AH[14] or AH[15] or AH[16] or AH[17] or AH[18] or AH[19] or AH[20] or AH[21]
	 or AH[22] or AH[23] or R_W or DIN[15] or int2generationenable_DAA000) begin
		int2generationenable_DAA000_D = 1'b0;
		if ( (AH[23:12] == 12'hDAA) & !R_W) begin //12'b1101_1010_1010
			int2generationenable_DAA000_D = DIN[15];
		end else begin
			int2generationenable_DAA000_D = int2generationenable_DAA000;
		end
	end
	
	//int2 active
	assign _INT2 = !(int2_DA9000 & int2generationenable_DAA000);

	//read gaylereg/dexxxx/(idebus via cpld), output to d15
	always @(irq_synch1 or forceasif_ideintrq_DA8000 or int2_DA9000 or
	 int2generationenable_DAA000 or AH[12] or AH[13] or AH[14] or AH[15] or AH[16] or
	 AH[17] or AH[18] or AH[19] or AH[20] or AH[21] or AH[22] or AH[23] or bit_from_sm or DDIN[7])
	 begin
		dh_ZD[15] = 1'b0;
		if (AH[23:12] == 12'hDA8) begin //12'b1101_1010_1000
			dh_ZD[15] = irq_synch1 | forceasif_ideintrq_DA8000;
		end else if (AH[23:12] == 12'hDA9) begin //12'b1101_1010_1001
			dh_ZD[15] = int2_DA9000;
		end else if (AH[23:12] == 12'hDAA) begin //12'b1101_1010_1010
			dh_ZD[15] = int2generationenable_DAA000;
		end else if (AH[23:12] == 12'hDAB) begin //12'b1101_1010_1011
			dh_ZD[15] = 1'b0;
		end else if (AH[23:16] == 8'hDE) begin //8'b1101_1110
			dh_ZD[15] = bit_from_sm;
		end else begin
			dh_ZD[15] = DDIN[7];
		end
	end

endmodule
