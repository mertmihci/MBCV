module BC_I (
    input clk,
    input FGI,
    output [11:0] PC,
    output [11:0] AR,
    output [15:0] IR,
    output [15:0] AC,
    output [15:0] DR
);
    wire memory_write,E_load, AC_load, AR_load, DR_load, IR_load, PC_load, TR_load, IEN_load, E_incr, AR_incr, DR_incr, PC_incr, AC_incr, IEN,
         E_reset, AC_reset, AR_reset, PC_reset, IEN_reset, E, Z_flag, N_flag;
    wire [2:0] bus_sel, alu_sel;

    // Instantiate datapath module
    datapath Datapath(
        .clk(clk),
        .E_load(E_load),
        .memory_write(memory_write),
        .AC_load(AC_load),
        .AR_load(AR_load),
        .DR_load(DR_load),
        .IR_load(IR_load),
        .PC_load(PC_load),
        .TR_load(TR_load),
        .IEN_load(IEN_load),
        .alu_sel(alu_sel),
        .bus_sel(bus_sel),
        .E_incr(E_incr),
        .AR_incr(AR_incr),
        .DR_incr(DR_incr),
        .PC_incr(PC_incr),
        .AC_incr(AC_incr),
        .E_reset(E_reset),
        .AC_reset(AC_reset),
        .AR_reset(AR_reset),
        .PC_reset(PC_reset),
        .IEN_reset(IEN_reset),
        .IEN_out(IEN),
        .E_out(E),
        .Z_flag(Z_flag),
        .N_flag(N_flag),
        .IR_out(IR),
        .DR_out(DR),
        .PC_out(PC),
        .AR_out(AR),
        .AC_out(AC)
    );

    // Instantiate control module
    control Control(
        .clk(clk),
        .FGI(FGI),
        .IEN(IEN),
        .E(E),
        .Z_flag(Z_flag),
        .N_flag(N_flag),
        .IR_in(IR),
        .DR_in(DR),
        .bus_sel(bus_sel),
        .alu_sel(alu_sel),
        .memory_write(memory_write),
        .AC_load(AC_load),
        .AR_load(AR_load),
        .DR_load(DR_load),
        .IR_load(IR_load),
        .PC_load(PC_load),
        .TR_load(TR_load),
        .IEN_load(IEN_load),
        .E_incr(E_incr),
        .AR_incr(AR_incr),
        .DR_incr(DR_incr),
        .PC_incr(PC_incr),
        .AC_incr(AC_incr),
        .E_reset(E_reset),
        .AC_reset(AC_reset),
        .AR_reset(AR_reset),
        .PC_reset(PC_reset),
        .IEN_reset(IEN_reset),
        .E_load(E_load)
    );
endmodule


// Instantiate your datapath and controller here, then connect them.
// iverilog -o BC_I.out BC_I.v datapath.v control.v alu.v bus_mux.v memory.v onebitreg.v sixteenbitreg.v timeseq.v twelvebitreg.v

