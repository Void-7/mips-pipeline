module EX_MEM(
    input clk,
    input [31:0] EX_pc,
    input [31:0] EX_pc_plus4,
    input [31:0] EX_inst,
    input [31:0] EX_busB,
    input [4:0] EX_Rw,
    input [31:0] EX_ALUresult,
    input EX_MemtoReg,EX_MemWrite,
    input EX_RegWrite,
    input EX_Branch,EX_nBranch,EX_BGEZ,EX_BGTZ,EX_BLEZ,EX_BLTZ,
    input EX_lb,EX_lbu,EX_sb,
    input EX_jal,EX_jalr,EX_jmp,

    output reg[31:0] MEM_pc,
    output reg[31:0] MEM_pc_plus4,
    output reg[31:0] MEM_inst,
    output reg[31:0] MEM_busB,
    output reg[4:0] MEM_Rw,
    output reg[31:0] MEM_ALUresult,
    output reg MEM_MemtoReg,MEM_MemWrite,
    output reg MEM_RegWrite,
    output reg MEM_Branch,MEM_nBranch,MEM_BGEZ,MEM_BGTZ,MEM_BLEZ,MEM_BLTZ,
    output reg MEM_lb,MEM_lbu,MEM_sb,
    output reg MEM_jal,MEM_jalr,MEM_jmp
);

initial begin
    MEM_MemtoReg=0;
    MEM_RegWrite=0;
    MEM_Branch=0;MEM_nBranch=0;
    MEM_BGEZ=0;MEM_BGTZ=0;MEM_BLEZ=0;MEM_BLTZ=0;
    MEM_lb=0;MEM_lbu=0;MEM_sb=0;
    MEM_jal=0;MEM_jmp=0;
    MEM_inst=32'b0;
    MEM_pc=32'b0;
    MEM_pc_plus4=32'b0;
    MEM_busB=32'b0;
    MEM_ALUresult=32'b0;
    MEM_Rw=5'b0;
    MEM_MemWrite=0;
    MEM_jalr=0;
end

always@(posedge clk)begin
    MEM_pc<=EX_pc;
    MEM_pc_plus4<=EX_pc_plus4;
    MEM_inst<=EX_inst;
    MEM_busB<=EX_busB;
    MEM_Rw<=EX_Rw;
    MEM_ALUresult<=EX_ALUresult;
    MEM_MemtoReg<=EX_MemtoReg;
    MEM_MemWrite<=EX_MemWrite;
    MEM_RegWrite<=EX_RegWrite;
    MEM_Branch<=EX_Branch;MEM_nBranch<=EX_nBranch;
    MEM_BGEZ<=EX_BGEZ;MEM_BGTZ<=EX_BGTZ;MEM_BLEZ<=EX_BLEZ;MEM_BLTZ<=EX_BLTZ;
    MEM_lb<=EX_lb;MEM_lbu<=EX_lbu;MEM_sb<=EX_sb;
    MEM_jal<=EX_jal;MEM_jmp<=EX_jmp;
    MEM_jalr<=EX_jalr;
end

endmodule