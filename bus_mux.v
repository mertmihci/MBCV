module bus_mux(
    input [2:0] bselect,
    input [15:0] I7, I6, I5, I4, I3,
    input [11:0] I2, I1,
    output [15:0] OUT
);

assign OUT = ( bselect == 3'b000) ? {16'b0}:
             ( bselect == 3'b001 ) ? {4'b0000, I1} :
             ( bselect == 3'b010 ) ? {4'b0000, I2} :
             ( bselect == 3'b011 ) ? I3 :
             ( bselect == 3'b100 ) ? I4 :
             ( bselect == 3'b101 ) ? I5 :
             ( bselect == 3'b110 ) ? I6 :
             ( bselect == 3'b111 ) ? I7 :
             16'b0; // Default case

endmodule



