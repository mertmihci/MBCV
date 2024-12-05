module sixteenbitreg(
    input clk, load, incr, reset,
    input [15:0] D_in,
    output reg [15:0] OUT
);

initial begin
    OUT = 16'b0;
end

always@(posedge clk)begin
    if(reset) OUT <= 16'b0;
    else begin
        if(load) OUT <= D_in;
        else if(incr) OUT <= OUT + 1'b1;
        else OUT <= OUT;
    end
end
endmodule
//iverilog -o sixteenbitreg.out sixteenbitreg.v