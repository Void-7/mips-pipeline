module im_4k(
    input [11:2] addr,
    output [31:0] dout
);
reg [31:0]  im [1023:0];

initial begin
    $readmemh("p0.txt", im);
end

assign dout = im[addr];

endmodule