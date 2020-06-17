module IF_ID(
    input clk,
    //input rst,
    input [31:0] pc,
    input [31:0] pc_plus4,
    input [31:0] inst,

    output reg[31:0] ID_pc,
    output reg[31:0] ID_pc_plus4,
    output reg[31:0] ID_inst
);

initial begin
    ID_pc=32'b0;
    ID_pc_plus4=32'b0;
    ID_inst=32'b0;
end

always@(posedge clk)begin
    ID_inst<=inst;
    ID_pc<=pc;
    ID_pc_plus4<=pc_plus4;
end


endmodule