

module ram_autoconfig( cpu_a21,cpu_a22,cpu_a23,
                 cpu_a1, cpu_a2, cpu_a3, cpu_a4, cpu_a5, cpu_a6,
                 cpu_a16,cpu_a17,cpu_a18,cpu_a19,cpu_a20,
                 cpu_d12,cpu_d13,cpu_d14,cpu_d15,
                 cpu_nas,cpu_nlds,cpu_nuds,cpu_clk,
                 cpu_nreset,
					  ramce,ramce2,
					  ram_d_OE
               );

	input cpu_a21,cpu_a22,cpu_a23; // cpu high addresses

	input cpu_a1, cpu_a2, cpu_a3, cpu_a4, cpu_a5, cpu_a6; // cpu low addresses for autoconfig
	input cpu_a16,cpu_a17,cpu_a18,cpu_a19,cpu_a20; // cpu high addresses for autoconfig

	output cpu_d12,cpu_d13,cpu_d14,cpu_d15; // autoconfig data in-out

	input cpu_nas,cpu_nlds,cpu_nuds; // cpu bus control signals
	input cpu_clk; // cpu clock

	input cpu_nreset; // cpu system reset

	output ramce,ramce2;
	
	output ram_d_OE;

	reg  [3:0] datout; // data out

	wire [7:0] high_addr;
	wire [5:0] low_addr;

assign cpu_d12 = datout[0];
assign cpu_d13 = datout[1];
assign cpu_d14 = datout[2];
assign cpu_d15 = datout[3];

assign ramce = cpu_a21 & !cpu_a22 & !cpu_a23; //Lower 2MB chip
assign ramce2 = !cpu_a21 & cpu_a22 & !cpu_a23; //Upper 2MB chip

	reg read_cycle; // if current cycle is read cycle
	reg write_cycle;
	reg autoconf_on;
	reg cpu_nas_z; // cpu /AS with 1 clock latency

	assign high_addr = {cpu_a23,cpu_a22,cpu_a21,cpu_a20,cpu_a19,cpu_a18,cpu_a17,cpu_a16};
	assign low_addr  = {cpu_a6,cpu_a5,cpu_a4,cpu_a3,cpu_a2,cpu_a1};


	// make clocked cpu_nas_z
	always @(posedge cpu_clk)
	begin
		cpu_nas_z <= cpu_nas;
	end

	// detect if current cycle is read or write cycle
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
	always @*
	begin
		case( low_addr )
		6'b000000: // $00
			datout <= 4'b1110;
		6'b000001: // $02
			datout <= 4'b0110; // 0110 for 2MB, 0111 for 4MB, 0000 for 8MB

		6'b000010: // $04
			datout <= 4'hE;
		6'b000011: // $06
			datout <= 4'hE;

		6'b000100: // $08
			datout <= 4'h3;
		6'b000101: // $0a
			datout <= 4'hF;

		6'b001000: // $10
			datout <= 4'hE;
		6'b001001: // $12
			datout <= 4'hE;

		6'b001010: // $14
			datout <= 4'hE;
		6'b001011: // $16
			datout <= 4'hE;

		6'b100000: // $40
			datout <= 4'b0000;
		6'b100001: // $42
			datout <= 4'b0000;

		default:
			datout <= 4'b1111;
		endcase
	end

	// out autoconfig data
	assign ram_d_OE = read_cycle==1 && high_addr==8'hE8 && autoconf_on==1;


	// autoconfig cycle on/off
	always @(posedge write_cycle,negedge cpu_nreset)
	begin
		if( cpu_nreset==0 ) // reset - begin autoconf
			autoconf_on <= 1;
		else
		begin
			if( high_addr==8'hE8 && low_addr[5:2]==4'b1001 ) // $E80048..$E8004E
				autoconf_on <= 0;
		end
	end



endmodule
