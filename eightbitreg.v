module eightbitreg(
    input clk, load, incr, reset,
    input [7:0] D_in,
    output reg [7:0] OUT
);

initial begin
    OUT = 8'b0;
end

always@(posedge clk)begin
    if(reset) OUT <= 8'b0;
    else begin
        if(load) OUT <= D_in;
        else if(incr) OUT <= OUT + 1'b1;
        else OUT <= OUT;
    end
end
endmodule
//iverilog -o eightbitreg.out eightbitreg.v