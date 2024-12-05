module twelvebitreg(
    input clk, load, incr, reset,
    input [11:0] D_in,
    output reg [11:0] OUT
);

initial begin
    OUT = 12'b10;
end

always@(posedge clk)begin
    if(reset) OUT <= 12'b0;
    else begin
        if(load) OUT <= D_in;
        else if(incr) OUT <= OUT + 1'b1;
        else OUT <= OUT;
    end
end
endmodule
//iverilog -o twelvebitreg.out twelvebitreg.v