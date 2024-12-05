module alu(
    input [2:0] aselect,
    input [15:0] AC_wire,
    input [15:0] DR_wire,
    input E,
    output [16:0] OUT,
    output reg CO, OVF, N_flag, Z_flag
);

assign OUT = ( aselect == 3'b000 ) ? (DR_wire & AC_wire) :              //AND
             ( aselect == 3'b001 ) ? {DR_wire + AC_wire} :              //ADD
             ( aselect == 3'b010 ) ? {DR_wire} :                        //TRANSFER DR
             ( aselect == 3'b011 ) ? {~AC_wire} :                       //COMPLEMENT AC
             ( aselect == 3'b100 ) ? {AC_wire[0], E, AC_wire[15:1]} :   //SHR
             ( aselect == 3'b101 ) ? {AC_wire, E} :                     //SHL
             ( aselect == 3'b110 ) ? 17'b0:                             //NOP
             ( aselect == 3'b111 ) ? 17'b0:                             //Empty
             17'b0; // Default case
initial begin
    CO = 1'b0;
    OVF = 1'b0;
    N_flag = 1'b0;
    Z_flag = 1'b0;
end
always @(*) begin
    CO <= OUT[16];
    N_flag <= OUT[15];
    Z_flag <= !(&(OUT[15:0]));
    if((DR_wire[15] == AC_wire[15]) & (OUT[15] != AC_wire[15] )) OVF <= 1;
    else OVF <= 0;
end
endmodule
//iverilog -o alu.out alu.v
