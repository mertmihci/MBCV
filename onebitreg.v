module onebitreg(
    input clk, load, incr, reset,
    input D_in,
    output reg OUT
);

initial begin
    OUT = 1'b0;
end

always@(posedge clk)begin
    if(reset) OUT <= 1'b0;
    else begin
        if(load) OUT <= D_in;
        else if(incr) OUT <= OUT + 1'b1;
        else OUT <= OUT;
    end
end
endmodule
//iverilog -o onebitreg.out onebitreg.v