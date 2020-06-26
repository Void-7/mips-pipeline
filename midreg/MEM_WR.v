module MEM_WR(
    input clk,
    input [31:0] MEM_pc,
    input [31:0] MEM_pc_plus4,
    input [31:0] MEM_inst,
    input [31:0] MEM_dout,
    input [31:0] MEM_ALUresult,
    input [4:0] MEM_Rw,
    input MEM_RegWrite,
    input MEM_MemtoReg,
    input MEM_jal,MEM_jalr,

    output reg[31:0] WR_pc,
    output reg[31:0] WR_pc_plus4,
    output reg[31:0] WR_dout,
    output reg[31:0] WR_ALUresult,
    output reg[4:0] WR_Rw,
    output reg WR_RegWrite,
    output reg WR_MemtoReg,
    output reg WR_jal,
    output reg WR_jalr
);
reg[31:0] WR_inst;

initial begin
    WR_pc=32'b0;
    WR_pc_plus4=32'b0;
    WR_dout=32'b0;
    WR_ALUresult=32'b0;
    WR_Rw=5'b0;
    WR_RegWrite=0;
    WR_MemtoReg=0;
end

always@(posedge clk)begin
    WR_pc<=MEM_pc;
    WR_pc_plus4<=MEM_pc_plus4;
    WR_dout<=MEM_dout;
    WR_ALUresult<=MEM_ALUresult;
    WR_Rw<=MEM_Rw;
    WR_RegWrite<=MEM_RegWrite;
    WR_MemtoReg<=MEM_MemtoReg;
    WR_jal<=MEM_jal;
    WR_jalr<=MEM_jalr;
    
    WR_inst<=MEM_inst;
end

endmodule