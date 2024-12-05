module memory(
    input clk, write,
    input [11:0] AR_wire,
    input [15:0] D_in,
    output [15:0] OUT
);

reg [15:0] memoryblock [4095:0];
assign OUT = memoryblock[AR_wire];

initial begin
    //**********************************ISR
    memoryblock[12'h0] = 16'h0;         //Left for PC to be stored
    memoryblock[12'h1] = 16'h4100;      //Branch to the ISR at M[0x100], 5 clock cycle
    //**********************************COMPUTER STARTS
    memoryblock[12'h2] = 16'h2050;      //LDA AC from M[0x050], 6 clock cycle
    memoryblock[12'h3] = 16'h8051;      //AND AC with indirect M[0x051], 6 clock cycle
    memoryblock[12'h4] = 16'h1053;      //ADD AC + M[0x053], 6 clock cycle
    memoryblock[12'h5] = 16'hB054;      //STA AC indirect M[0x054], 5 clock cycle
    memoryblock[12'h6] = 16'h50EF;      //BSA to 0x0F0 and save return address to 0x0EF,6 clock cycle
    memoryblock[12'h7] = 16'h6050;      //ISZ, 7 clock cycles
    memoryblock[12'h8] = 16'h7001;      //HALT computer, This instruction expected to be skipped.
    memoryblock[12'h9] = 16'h7800;      //CLA clear accumulator, 4 clock cycles.
    memoryblock[12'hA] = 16'h7200;      //CMA complement accumulator, 4 clock cycles
    memoryblock[12'hB] = 16'h7080;      //CIR circular shift right, 4 clock cyles
    memoryblock[12'hC] = 16'h7040;      //CIL circular shift left, 4 clock cylces
    memoryblock[12'hD] = 16'h7100;      //CME complement E, 4 clock cycles
    memoryblock[12'hE] = 16'h7800;      //CLA clear accumulator, 4 cycles
    memoryblock[12'hF] = 16'h7004;      //SZA skips next instruction if AC is zero, 4 clock cycles
    memoryblock[12'h10] = 16'h7001;     //HALT, this instruction expected to be skipped.
    memoryblock[12'h11] = 16'hF080;     //ION enables interrupt, 4 clock cycles
    memoryblock[12'h12] = 16'h7020;     //INCAC incerement AC, 4 clock cycles
    memoryblock[12'h13] = 16'h7010;     //SPA skips next instruction if AC is positive, 4 clock cycles
    memoryblock[12'h14] = 16'h7001;     //HALT, this instruction expected to be skipped.
    memoryblock[12'h15] = 16'h2057;     //LDA AC from M[0x057], 6 clock cycle
    memoryblock[12'h16] = 16'h7008;     //SNA skips next instruction if AC is negative, 4 clock cycles
    memoryblock[12'h17] = 16'h7001;     //HALT, this instruction expected to be skipped.
    memoryblock[12'h18] = 16'h7400;     //CLE clears E, 4 clock cycles
    memoryblock[12'h19] = 16'h7002;     //SZE skips next instruction if E is zero, 4 clock cycles
    memoryblock[12'h1A] = 16'hF040;     //IOF clears IEN, this instruction expected to be skipped.
    memoryblock[12'h1B] = 16'h7001;     //HALT
    //*****************************DATAS (Except 12'h0F0)
    memoryblock[12'h50] = 16'hFFFF;     //DATA to load AC
    memoryblock[12'h51] = 16'h0052;     //Pointer to address 12'b052
    memoryblock[12'h52] = 16'h1111;     //DATA to AND AC
    memoryblock[12'h53] = 16'h0002;     //DATA to ADD AC
    memoryblock[12'h54] = 16'h00FF;     //Pointer to address 0x0FF
    memoryblock[12'h56] = 16'h1233;     //DATA used in ISR
    memoryblock[12'h57] = 16'hFFFF;
    memoryblock[12'hEF] = 16'h0;        //PC value will be stored here
    memoryblock[12'hF0] = 16'hC0EF;      //BUN indirect to Restore PC, 5 clock cycle
    memoryblock[12'h0FF] = 16'h0;       //AC Value will be stored here
    //*****************************ISR
    memoryblock[12'h100] = 16'h2056;    //LDA AC from M[0x056], 6 clock cycles
    memoryblock[12'h101] = 16'h7020;    //INCAC, 4 clock cycles
    memoryblock[12'h102] = 16'hC000;    //BUN, leave ISR, 5 clock cycles
    end


always@(posedge clk)begin
    if(write) memoryblock[AR_wire] <= D_in;
    else memoryblock[AR_wire] <= memoryblock[AR_wire];
end
endmodule
//iverilog -o memory.out memory.v