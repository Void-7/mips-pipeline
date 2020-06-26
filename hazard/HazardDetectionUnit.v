module HazardDetectionUnit(
    input[4:0]IFID_Rs,
    input[4:0]IFID_Rt,
    input[4:0]IDEX_Rt,
    input IDEX_MemtoReg,

    output pc_stall_en,
    output IFID_Wr,
    output IDEX_Clear
);
wire condition;
assign condition=(IDEX_MemtoReg && (IFID_Rs==IDEX_Rt ||IFID_Rt==IDEX_Rt));

assign pc_stall_en=(condition)?1'b1:1'b0;
assign IFID_Wr=(condition)?1'b0:1'b1;
assign IDEX_Clear=(condition)?1'b1:1'b0;

endmodule

module IDEX_SigMux(
    input IDEX_Clear,
    input [31:0] ID_pc,
    input [31:0] ID_pc_plus4,
    input [31:0] ID_npc,
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

    output reg[31:0] real_ID_pc,
    output reg[31:0] real_ID_pc_plus4,
    output reg[31:0] real_ID_npc,
    output reg[31:0] real_ID_inst,
    output reg[31:0] real_ID_immExt,
    output reg[31:0] real_ID_busA,
    output reg[31:0] real_ID_busB,
    output reg[4:0] real_ID_ALUctr,
    output reg[4:0] real_ID_shamt,
    output reg real_ID_RegDST,
    output reg real_ID_ALUSrc,
    output reg real_ID_MemtoReg,
    output reg real_ID_RegWrite,
    output reg real_ID_Memwrite,
    output reg real_ID_Branch,real_ID_nBranch,real_ID_BGEZ,real_ID_BGTZ,real_ID_BLEZ,real_ID_BLTZ,
    output reg real_ID_lb,real_ID_lbu,real_ID_sb,
    output reg real_ID_jal,real_ID_jmp,real_ID_jr,real_ID_jalr
);

always@(*)begin
    if(IDEX_Clear)begin
        real_ID_pc<=0;
        real_ID_pc_plus4<=0;
        real_ID_npc<=0;
        real_ID_inst<=0;
        real_ID_immExt<=0;
        real_ID_busA<=0;
        real_ID_busB<=0;

        real_ID_RegDST<=0;
        real_ID_ALUSrc<=0;
        real_ID_MemtoReg<=0;
        real_ID_RegWrite<=0;
        real_ID_Memwrite<=0;
        real_ID_Branch<=ID_Branch;real_ID_nBranch<=0;
        real_ID_BGEZ<=0;real_ID_BGTZ<=0;real_ID_BLEZ<=0;real_ID_BLTZ<=0;
        real_ID_lb<=0;real_ID_lbu<=0;real_ID_sb<=0;
        real_ID_jal<=0;real_ID_jmp<=0;real_ID_jr<=0;real_ID_jalr<=0;
        real_ID_ALUctr<=0;
        real_ID_shamt<=0;
    end
    else begin
        real_ID_pc<=ID_pc;
        real_ID_pc_plus4<=ID_pc_plus4;
        real_ID_npc<=ID_npc;
        real_ID_inst<=ID_inst;
        real_ID_immExt<=ID_immExt;
        real_ID_busA<=ID_busA;
        real_ID_busB<=ID_busB;

        real_ID_RegDST<=ID_RegDST;
        real_ID_ALUSrc<=ID_ALUSrc;
        real_ID_MemtoReg<=ID_MemtoReg;
        real_ID_RegWrite<=ID_RegWrite;
        real_ID_Memwrite<=ID_Memwrite;
        real_ID_Branch<=ID_Branch;real_ID_nBranch<=ID_nBranch;
        real_ID_BGEZ<=ID_BGEZ;real_ID_BGTZ<=ID_BGTZ;real_ID_BLEZ<=ID_BLEZ;real_ID_BLTZ<=ID_BLTZ;
        real_ID_lb<=ID_lb;real_ID_lbu<=ID_lbu;real_ID_sb<=ID_sb;
        real_ID_jal<=ID_jal;real_ID_jmp<=ID_jmp;real_ID_jr<=ID_jr;real_ID_jalr<=ID_jalr;
        real_ID_ALUctr<=ID_ALUctr;
        real_ID_shamt<=ID_shamt;
    end
end


endmodule