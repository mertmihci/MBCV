module control(
    input clk,
    input wire FGI, IEN, E, Z_flag, N_flag,
    input wire [15:0] IR_in,
    input wire [15:0] DR_in,
    output wire [2:0] bus_sel, alu_sel,
    output wire memory_write, AC_load, AR_load, DR_load, IR_load, PC_load, TR_load, IEN_load,
    output wire E_incr, AR_incr, DR_incr, PC_incr, AC_incr,
    output wire E_reset, AC_reset, AR_reset, PC_reset, IEN_reset, E_load
);

wire t_inc, t_reset;
wire [7:0] b_encode, alu_encode;
reg R, S;
wire [15:0] T_out;
reg [7:0] D_signals; 

timeseq Timerr(clk, t_inc, t_reset, T_out);

initial begin
    R = 1'b0;
    S = 1'b1;
    D_signals = 8'b0;
end


//BUS SELECTION
assign b_encode[0] = 0;                                                     //NONE 
assign b_encode[1] = (D_signals[4] & T_out[4]) | (D_signals[5] & T_out[5]); //AR
assign b_encode[2] = T_out[0] | (T_out[4] & D_signals[5]);                                              //PC
assign b_encode[3] = D_signals[6] & T_out[6];                               //DR
assign b_encode[4] = D_signals[3] & T_out[4];                               //AC
assign b_encode[5] = (~R) & T_out[2];                                       //IR
assign b_encode[6] = R & T_out[1];                                          //TR
assign b_encode[7] = ((~R) & T_out[1] | (~D_signals[7] & IR_in[15] & T_out[3]) | T_out[4] & (D_signals[0] | D_signals[1] | D_signals[2] | D_signals [6]));//Memory

assign bus_sel = (b_encode == 8'h01) ? {3'b000} :
                 (b_encode == 8'h02) ? {3'b001} :
                 (b_encode == 8'h04) ? {3'b010} :
                 (b_encode == 8'h08) ? {3'b011} :
                 (b_encode == 8'h10) ? {3'b100} :
                 (b_encode == 8'h20) ? {3'b101} :
                 (b_encode == 8'h40) ? {3'b110} :
                 (b_encode == 8'h80) ? {3'b111} :
                  3'b0; // Default case
//BUS SELECTION

//ALU SELECTION
assign alu_encode[0] = T_out[5] & D_signals[0];        //AND
assign alu_encode[1] = T_out[5] & D_signals[1];        //ADD
assign alu_encode[2] = T_out[5] & D_signals[2];        //LOAD
assign alu_encode[3] = T_out[3] & (IR_in == 16'h7200); //Complement AC
assign alu_encode[4] = T_out[3] & (IR_in == 16'h7080); //SHR
assign alu_encode[5] = T_out[3] & (IR_in == 16'h7040); //SHL
assign alu_encode[6] = 0;                              //NOP
assign alu_encode[7] = 0;                              //NOP

assign alu_sel = (alu_encode == 8'h01) ? {3'b000} :
                 (alu_encode == 8'h02) ? {3'b001} :
                 (alu_encode == 8'h04) ? {3'b010} :
                 (alu_encode == 8'h08) ? {3'b011} :
                 (alu_encode == 8'h10) ? {3'b100} :
                 (alu_encode == 8'h20) ? {3'b101} :
                 (alu_encode == 8'h40) ? {3'b110} :
                 (alu_encode == 8'h80) ? {3'b111} :
                 3'b0; // Default case
//ALU SELECTION

//LOAD SIGNALS
assign memory_write = (R & T_out[1]) | (((D_signals[3] | D_signals[5]) & T_out[4]) | (T_out[6] & D_signals[6]));
assign AC_load =  (T_out[3] & ((IR_in == 16'h7040) | (IR_in == 16'h7080) | (IR_in == 16'h7200))) | 
                  (T_out[5] & (D_signals[0] | D_signals[1] | D_signals[2]));
assign E_load = AC_load & ((IR_in == 16'h7040) | (IR_in == 16'h7080) | D_signals[1] );
assign AR_load = ((~R) & (T_out[0] | T_out[2])) | (IR_in[15] & T_out[3]);
assign DR_load = T_out[4] & (D_signals[0] | D_signals[1] | D_signals[2] | D_signals[6]);
assign IR_load = (~R) & T_out[1];
assign PC_load = (T_out[4] &  D_signals[4]) | (T_out[5] & D_signals[5]);
assign TR_load = R & T_out[0];
assign IEN_load = T_out[3] & (IR_in == 16'hF080);
//LOAD SIGNALS

//INCREMENT SIGNALS
assign t_inc = ~t_reset;
assign E_incr = T_out[3] & (IR_in == 16'h7100); //COMPLEMENT E
assign AR_incr = T_out[4] & D_signals[5];
assign AC_incr = T_out[3] & (IR_in == 16'h7020);
assign DR_incr = T_out[5] & D_signals[6];
assign PC_incr = (R & T_out[2]) | ((~R) & (T_out[1] | (T_out[3] & (((IR_in == 16'h7002) & (~E)) | ((IR_in == 16'h7004) & Z_flag) | ((IR_in == 16'h7008) & (N_flag)) |
             ((IR_in == 16'h7010) & (~N_flag)))) | (T_out[6] & (DR_in == 16'h0)))) ;
//INCREMENT SIGNALS

//RESET SIGNALS
assign t_reset = (D_signals[7] & T_out[3]) | (D_signals[0] & T_out[5]) | (D_signals[1] & T_out[5]) | (D_signals[2] & T_out[5]) | (D_signals[3] & T_out[4]) |
                 (D_signals[4] & T_out[4]) | (D_signals[5] & T_out[5]) | (D_signals[6] & T_out[6]) | (R & T_out[2]) | (~S);
assign PC_reset = R & T_out[1];
assign E_reset = T_out[3] & (IR_in == 16'h7400);
assign AC_reset = T_out[3] & (IR_in == 16'h7800);
assign AR_reset = R & T_out[0];
assign IEN_reset = (R & T_out[2]) | (T_out[3] & (IR_in == 16'hF040));
//RESET SIGNALS

always@(*) begin                        //Adjusting D[n]
    case(IR_in[14:12])
        3'b000: D_signals = 8'b00000001;
        3'b001: D_signals = 8'b00000010;
        3'b010: D_signals = 8'b00000100;
        3'b011: D_signals = 8'b00001000;
        3'b100: D_signals = 8'b00010000;
        3'b101: D_signals = 8'b00100000;
        3'b110: D_signals = 8'b01000000;
        3'b111: D_signals = 8'b10000000;
        default D_signals = 8'b0;
    endcase
end

always@(posedge clk) begin              //Adjust R
    if((~T_out[0]) & (~T_out[1]) & (~T_out[2]) & IEN & FGI) R <= 1;
    else if(R & T_out[2]) R <= 0;
    else R <= R;
end

always@(posedge clk) begin              //Adjust S
    if (T_out[3] & (IR_in == 16'h7001)) S <= 0;
    else S <= S;
end

endmodule
//iverilog -o control.out control.v timeseq.v