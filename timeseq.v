module timeseq(
input clk,
input incr,
input reset, 
output reg [15:0] OUT
);

reg [3:0] counter;

initial begin
    counter = 4'b0;
    OUT = 16'b0;
end

always@(posedge clk) begin

    if(reset) counter <= 0;
    else if(incr) counter += 1;
    else counter <= counter;

end

always@(*) begin

    case(counter)
        4'b0000: OUT = 16'h1;
        4'b0001: OUT = 16'h2;
        4'b0010: OUT = 16'h4;
        4'b0011: OUT = 16'h8;
        4'b0100: OUT = 16'h10;
        4'b0101: OUT = 16'h20;
        4'b0110: OUT = 16'h40;
        4'b0111: OUT = 16'h80;
        4'b1000: OUT = 16'h100;
        4'b1001: OUT = 16'h200;
        4'b1010: OUT = 16'h400;
        4'b1011: OUT = 16'h800;
        4'b1100: OUT = 16'h1000;
        4'b1101: OUT = 16'h2000;
        4'b1110: OUT = 16'h4000;
        4'b1111: OUT = 16'h8000;
        default: OUT = 16'b0;
    endcase

end
endmodule
//iverilog -o timeseq.out timeseq.v