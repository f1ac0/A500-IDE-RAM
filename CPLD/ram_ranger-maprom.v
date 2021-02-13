`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:39:17 02/07/2021 
// Design Name: 
// Module Name:    ram_ranger-maprom 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ram_ranger_maprom(
	input [23:12] AH,
	input cpu_nuds,
	input _RST,
	input RW,
	output [15:12] control_d,
	output control_oe,
	output OVR, //positive logic here !
//	output DTACK, //positive logic here !
	output ramce
	);


//maprom
	reg [1:0] maprom_written = 2'b0;
	reg maprom_on = 1'b0;
	wire control_access = AH[23:12] == 12'hE9C;
	wire control_read = control_access & RW;
	wire control_write = control_access & !RW;

//address decoding
	wire ram9_range = ( AH[23:20]==4'b1100 | AH[23:19]==5'b11010 ); //C00000-D7FFFF, 1.5M, 16 bits, not autoconfig
//	wire ram9_range = ( AH[23:20]==4'b1100 ); //C00000-CFFFFF, 1M, 16 bits, not autoconfig
//	wire ram9_range = ( AH[23:19]==5'b11000 ); //C00000-C7FFFF, 512k, 16 bits, not autoconfig
	wire rom9_range = ( AH[23:19]==5'b11111 ); //F80000-FFFFFF, .5M, 16 bits
	wire maprom_write = rom9_range & !RW;
	wire maprom_read = rom9_range & maprom_on;

//maprom activation
	always @(negedge cpu_nuds)
	begin
		if( control_write ) begin // reset - write in control
			maprom_written <= 2'b0;
		end else	begin
			if( maprom_write ) begin // maprom write
				if(~&(maprom_written)) //sample multiple writes otherwise false positives during power up
					maprom_written <= maprom_written+1;
			end
		end
	end
	always @(negedge _RST) begin
		maprom_on <= &(maprom_written);
	end

//response from our device
	assign control_d[15:12] = {maprom_on, 3'b0}; //autoconfig data
	assign control_oe = control_read;
	assign ramce = (ram9_range | maprom_write | maprom_read);
	assign OVR = (ram9_range | maprom_write | maprom_read | control_access) ; //chipset override, positive logic here !
//	assign DTACK = 1'b0; //ram1ce;

endmodule
