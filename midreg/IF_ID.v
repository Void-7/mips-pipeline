module IF_ID(
    input clk,
    //input rst,
    input [31:0] pc,
    input [31:0] pc_plus4,
    input [31:0] inst,
    input IFID_Wr,
    input Flush,

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
    if(IFID_Wr&&!Flush)begin    //only ifid wr is true
        ID_inst<=inst;
        ID_pc<=pc;
        ID_pc_plus4<=pc_plus4;
    end
    if(Flush)begin
        ID_inst<=0;
        ID_pc<=0;
        ID_pc_plus4<=0;
    end
end

endmodule