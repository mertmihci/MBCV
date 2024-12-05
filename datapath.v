module datapath(
    input wire clk, E_load, memory_write, AC_load, AR_load, DR_load, IR_load, PC_load, TR_load, IEN_load,
    input wire [2:0] alu_sel, bus_sel, 
    input wire E_incr, AR_incr, DR_incr, PC_incr, AC_incr,
    input wire E_reset, AC_reset, AR_reset, PC_reset, IEN_reset,
    output wire IEN_out, E_out, Z_flag, N_flag,
    output wire [15:0] IR_out, DR_out, 
    output wire [11:0] PC_out, AR_out,
    output wire [15:0] AC_out
);
wire IEN_incr, IR_incr, TR_incr, DR_reset, IR_reset, TR_reset;
assign IEN_incr = 0; //No increment for IEN, Just set and reset.
assign IR_incr = 0;  //No increment for IR.
assign TR_incr = 0;  //No increment for TR.
assign DR_reset = 0; //No reset for DR.
assign IR_reset = 0; //No reset for IR.
assign TR_reset = 0; //No reset for TR.


wire [15:0] TR_out, memory_out, D_in;
wire [16:0] alu_out;
wire CO, OVF;


memory          Memory(clk, memory_write, AR_out, D_in, memory_out);
bus_mux         BUS(bus_sel, memory_out, TR_out, IR_out, AC_out, DR_out, PC_out, AR_out, D_in);
twelvebitreg    AR(clk, AR_load, AR_incr, AR_reset, D_in, AR_out);
twelvebitreg    PC(clk, PC_load, PC_incr, PC_reset, D_in, PC_out);
sixteenbitreg   DR(clk, DR_load, DR_incr, DR_reset, D_in, DR_out);
sixteenbitreg   AC(clk, AC_load, AC_incr, AC_reset, alu_out[15:0], AC_out);
alu             ALU(alu_sel, AC_out, DR_out, E_out, alu_out, CO, OVF, N_flag, Z_flag);
onebitreg       E(clk, E_load, E_incr, E_reset, alu_out[16], E_out);
sixteenbitreg   IR(clk, IR_load, IR_incr, IR_reset, D_in, IR_out);
sixteenbitreg   TR(clk, TR_load, TR_incr, TR_reset, D_in, TR_out);
onebitreg       IEN(clk, IEN_load, IEN_incr, IEN_reset, IEN_load, IEN_out);

endmodule
//iverilog -o datapath.out datapath.v memory.v bus_mux.v twelvebitreg.v sixteenbitreg.v alu.v onebitreg.v
