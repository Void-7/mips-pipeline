module testbench();

reg clk;
reg rst;

mips mips(clk, rst);

initial begin
    clk <= 0;
    rst <= 1;
end

always begin
    #35 rst <= 0;
end

always #40 clk=~clk;

endmodule