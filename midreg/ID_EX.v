module ID_EX(
    input clk,
    //input rst,
    input [31:0] ID_pc,
    input [31:0] ID_pc_plus4,
    input [31:0] ID_inst,
    input [31:0] ID_immExt,
    input [31:0] ID_busA,
    input [31:0] ID_busB,
    input ID_RegDST,
    input ID_ALUSrc,
    input ID_MemtoReg,
    input ID_RegWrite,
    input ID_Memwrite,
    input ID_Branch,ID_nBranch,ID_BGEZ,ID_BGTZ,ID_BLEZ,ID_BLTZ,
    input ID_lb,ID_lbu,ID_sb,
    input ID_jal,ID_jmp,ID_jr,ID_jalr,
    input [4:0] ID_ALUctr,
    input [4:0] ID_shamt,

    output reg[31:0] EX_pc,
    output reg[31:0] EX_pc_plus4,
    output reg[31:0] EX_inst,
    output reg[31:0] EX_immExt,
    output reg[31:0] EX_busA,
    output reg[31:0] EX_busB,
    output reg[4:0] EX_ALUctr,
    output reg[4:0] EX_shamt,
    output reg EX_RegDST,
    output reg EX_ALUSrc,
    output reg EX_MemtoReg,
    output reg EX_RegWrite,
    output reg EX_Memwrite,
    output reg EX_Branch,EX_nBranch,EX_BGEZ,EX_BGTZ,EX_BLEZ,EX_BLTZ,
    output reg EX_lb,EX_lbu,EX_sb,
    output reg EX_jal,EX_jmp,EX_jr,EX_jalr,
    output reg EX_ExtOp

);

initial begin
    EX_RegDST=0;
    EX_ALUSrc=0;
    EX_MemtoReg=0;
    EX_RegWrite=0;
    EX_Memwrite=0;
    EX_Branch=0;EX_nBranch=0;
    EX_BGEZ=0;EX_BGTZ=0;EX_BLEZ=0;EX_BLTZ=0;
    EX_lb=0;EX_lbu=0;EX_sb=0;EX_jr=0;EX_jalr=0;
    EX_jal=0;EX_jmp=0;
    EX_immExt=32'b0;
    EX_inst=32'b0;
    EX_pc=32'b0;
    EX_pc_plus4=32'b0;
    EX_ALUctr=5'b0;
    EX_busA=32'b0;
    EX_busB=32'b0;
    EX_shamt=5'b0;
end

always@(posedge clk)begin
    EX_pc<=ID_pc;
    EX_pc_plus4<=ID_pc_plus4;
    EX_inst<=ID_inst;
    EX_immExt<=ID_immExt;
    EX_busA<=ID_busA;
    EX_busB<=ID_busB;

    EX_RegDST<=ID_RegDST;
    EX_ALUSrc<=ID_ALUSrc;
    EX_MemtoReg<=ID_MemtoReg;
    EX_RegWrite<=ID_RegWrite;
    EX_Memwrite<=ID_Memwrite;
    EX_Branch<=ID_Branch;EX_nBranch<=ID_nBranch;
    EX_BGEZ<=ID_BGEZ;EX_BGTZ<=ID_BGTZ;EX_BLEZ<=ID_BLEZ;EX_BLTZ<=ID_BLTZ;
    EX_lb<=ID_lb;EX_lbu<=ID_lbu;EX_sb<=ID_sb;
    EX_jal<=ID_jal;EX_jmp<=ID_jmp;EX_jr<=ID_jr;EX_jalr<=ID_jalr;
    EX_ALUctr<=ID_ALUctr;
    EX_shamt<=ID_shamt;

end

endmodule