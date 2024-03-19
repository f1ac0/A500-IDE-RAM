// Additional RAM idea inspired by Sector101
// https://blog.sector101.co.uk/2019/07/20/amiga-500-2mb-handwired-fastram-expansion/
// Amiga Memory map
// https://amigacoding.com/index.php?title=Amiga_memory_map
//
//
 
`define RAM_COMBO 1
//`define RAM_AUTOCONFIG 1
//`define RAM_AUTOCONFIG_ORIGINAL 1
//`define RAM_RANGER_MAPROM 1
//`define RAM_NONE 1
`define OPTPIN_LED 1
//`define OPTPIN_CONFIG 1

module a500_ide_ram(
//68000 bus
	input _AS,
	input R_W,
	input _UDS,
	input _LDS,
	input _RESET,
	input CLK,
	input [23:12] AH,
	input [6:1] AL, //6,5,1 added for RAM
	inout [15:0] D,
	output _DTACK,
	output _DTACK2,
	output _OVR,
	output _OVR2,
	output _OVR3,
	output _INT2,
	output _INT22,

//IDE
//	input IORDY,
	input INTRQ,
	input _ACTIVE,
	inout [15:0] DD,
	output _DRESET,
	output [2:0] DA,
	output [1:0] _CS,
	output _DIOW,
	output _DIOR,

//OTHER
	output _LED,
`ifdef OPTPIN_LED
	output OPTPIN_I,
	output OPTPIN_O,
`endif
`ifdef OPTPIN_CONFIG
	input OPTPIN_I,
	output OPTPIN_O,
`endif
	output RAM1CE, //RAM
	output RAM2CE //RAM
	);


//RAM
	wire ram_d_OE;
	wire [15:12] ram_d;
	wire ram_ovr_range;
	wire ram_dtack_range;
	wire _configin;
	wire _configout;
	assign RAM2CE=1'b0;
	
`ifdef RAM_COMBO
	//ram selectable autoconfig or ranger+maprom
	ram_combo ram(
		AH[23:12],
		AL[6:1],
		D[15:13],
		_RESET,
		CLK,
		_UDS,
		R_W,
		_configin,
		_configout,
		ram_d,
		ram_d_OE,
		ram_ovr_range,		
		ram_dtack_range,		
		RAM1CE
//		RAM2CE
	);
`endif
`ifdef RAM_AUTOCONFIG
	//ram_autoconfig
	assign ram_ovr_range=1'b0;
	ram_autoconfig ram(
		AH[23:16],
		AL[6:1],
		D[15:13],
		_RESET,
		_UDS,
		R_W,
		_configin,
		_configout,
		ram_d,
		ram_d_OE,
//		ram_ovr_range,		
		ram_dtack_range,		
		RAM1CE
//		RAM2CE
	);
`endif
`ifdef RAM_AUTOCONFIG_ORIGINAL
	//ram_autoconfig_original
	assign ram_ovr_range=1'b0;
	ram_autoconfig_original ram(
		AH[23:16],
		AL[6:1],
		D[15:13],
		_AS,
		_LDS,
		_UDS,
		CLK,
		_RESET,
		_configin,
		_configout,
		ram_d[15:12],
		ram_d_OE,
		ram_dtack_range,		
		RAM1CE
//		RAM2CE
	);
`endif
`ifdef RAM_RANGER_MAPROM
	//ram_ranger_maprom
//	assign ram_d_OE=1'b0;
	assign _configout=1'b0;
	assign ram_dtack_range=1'b0;
	ram_ranger_maprom ram(
		AH[23:12],
		_UDS,
		_RESET,
		R_W,
		ram_d[15:12],
		ram_d_OE,
		ram_ovr_range,
		RAM1CE
	);
`endif
`ifdef RAM_NONE
	assign ram_ovr_range=1'b0;
	assign _configout=1'b0;
	assign ram_dtack_range=1'b0;
	assign RAM1CE=1'b0;
	assign ram_d_OE=1'b0;
`endif

//IDE
	wire iderange;
	wire ide_int2;
	wire [15:0]ide_d, ide_d8_oe, ide_d0_oe;
	wire [15:0]ide_dd, ide_dd8_oe, ide_dd0_oe;
	wire Xled_OE, Xled_ZD, Xledpos;

	ide ide(
//68000 bus
		_AS,
		R_W,
		_UDS,
		_LDS,
		_RESET,
		CLK,
		AH[23:12],
		AL[4:2],
		D[15:0],
		ide_d[15:0],
		ide_d8_oe,
		ide_d0_oe,
		iderange,
		ide_int2,
//IDE
//		IORDY,
		INTRQ,
		_ACTIVE,
		DD[15:0],
		ide_dd[15:0],
		ide_dd8_oe,
		ide_dd0_oe,
		_DRESET,
		DA[2:0],
		_CS[1:0],
		_DIOW,
		_DIOR,
//LEDs
		_LED,
		Xled_OE,
		Xled_ZD,
		Xledpos
	);

	assign _INT2 = (!ide_int2) ? 1'b0 : 1'bz;
	assign _INT22 = (!ide_int2) ? 1'b0 : 1'bz;
	assign _OVR3 = (iderange | ram_ovr_range) ? 1'b0 : 1'bz;
	assign _OVR2 = (iderange | ram_ovr_range) ? 1'b0 : 1'bz;
	assign _OVR = (iderange | ram_ovr_range) ? 1'b0 : 1'bz;
	assign _DTACK2 = (!_AS & (iderange | ram_dtack_range)) ? 1'b0 : 1'bz;
	assign _DTACK = (!_AS & (iderange | ram_dtack_range)) ? 1'b0 : 1'bz;
	assign DD[15:8] = (ide_dd8_oe) ? ide_dd[15:8] : 8'bz;
	assign DD[7:0] = (ide_dd0_oe) ? ide_dd[7:0] : 8'bz;
	assign D[15:12] = (ide_d8_oe) ? ide_d[15:12] : (ram_d_OE ? ram_d[15:12] : 4'bz);
	assign D[11:8] = (ide_d8_oe) ? ide_d[11:8] : 4'bz;
	assign D[7:0] = (ide_d0_oe) ? ide_d[7:0] : 8'bz;

	//Optional IO
`ifdef OPTPIN_LED
	assign OPTPIN_I = (Xled_OE) ? Xled_ZD : 1'bz;
	assign OPTPIN_O = Xledpos;
	assign _configin = 1'b0;
`endif
`ifdef OPTPIN_CONFIG
	assign _configin = OPTPIN_I;
	assign OPTPIN_O = _configout;
`endif

endmodule
