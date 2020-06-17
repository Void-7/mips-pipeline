module mips(
    input clk,
    input rst
);

wire[31:0] pc;
wire[31:0] pc_plus4;
wire[31:0]instruction;
//id
wire[31:0] id_pc;
wire[31:0] id_pc_plus4;
wire[31:0] id_inst;
wire[31:0] id_busA;
wire[31:0] id_busB;
wire[31:0] id_immExt;
wire id_RegWr;
wire id_RegDst;
wire id_ExtOp;
wire id_ALUsrc;
wire id_Branch,id_nBranch,id_BGEZ,id_BGTZ,id_BLTZ,id_BLEZ;
wire id_jmp,id_jal,id_jr,id_jalr;
wire id_lb,id_lbu,id_sb;
wire id_MemWr;
wire id_MemtoReg;
wire[4:0] id_ALUctr;
wire[4:0] id_shamt;
//ex
wire[31:0] ex_inst;
wire[31:0] ex_pc;
wire[31:0] ex_pc_plus4;
wire[31:0] ex_immEXt;
wire[31:0] ex_busA;
wire[31:0] ex_busB;
wire ex_RegWr;
wire ex_RegDst;
wire ex_ALUsrc;
wire ex_Branch,ex_nBranch,ex_BGEZ,ex_BGTZ,ex_BLEZ,ex_BLTZ;
wire ex_Jmp,ex_jal,ex_jr,ex_jalr,ex_lb,ex_lbu,ex_sb;
wire ex_MemWr;
wire ex_MemtoReg;
wire[4:0] ex_ALUctr;
wire[4:0] ex_shamt;
wire[31:0] EX_inst;
wire[31:0] EX_pc;
wire[31:0] EX_pc_plus4;
wire[31:0] EX_alu_result;
wire[4:0] EX_Rw;
wire EX_RegWr;
wire EX_lb,EX_lbu,EX_sb;
wire EX_MemWr;
wire EX_MemtoReg;
wire EX_zero;
wire[31:0] EX_npc;

wire[31:0]mem_pc;
wire[31:0]mem_pc_plus4;
wire[31:0]mem_npc;
wire[31:0]mem_inst;
wire[31:0]mem_busB;
wire[4:0]mem_Rw;
wire[31:0]mem_alu_result;
wire mem_zero;
wire mem_MemtoReg,mem_MemWr;
wire mem_RegWr;
wire mem_Branch,mem_nBranch,mem_BGEZ,mem_BGTZ,mem_BLEZ,mem_BLTZ;
wire mem_lb,mem_lbu,mem_sb;
wire mem_jal,mem_jmp;

wire[31:0]WR_pc,WR_pc_plus4,WR_rdata,WR_alu_result;
wire[4:0]WR_Rw;
wire WR_RegWr,WR_MemtoReg;

wire[31:0]WR_busW;

wire[31:0]MEM_rdata;
wire[31:0]MEM_npc;


//IF
IF IF_(
    .npc(MEM_npc),.clk(clk),.rst(rst),
    .inst(instruction),.IF_pc_plus4(pc_plus4),.IF_pc(pc)
);

//ID/ID midreg
IF_ID reg_IFID(
    .clk(clk),.pc(pc),.pc_plus4(pc_plus4),.inst(instruction),
    .ID_pc(id_pc),.ID_pc_plus4(id_pc_plus4),.ID_inst(id_inst)
);

//ID
ID ID_(
    .clk(clk),.rst(rst),.inst(id_inst),.wreg(WR_Rw),.Rs(id_inst[25:21]),.Rt(id_inst[20:16]),
    .wdata(WR_busW),.RegWrite(WR_RegWr),.imm16(instruction[15:0]),

    .ID_busA(id_busA),.ID_busB(id_busB),.ID_immExt(id_immExt),.ID_RegDST(id_RegDst),
    .ID_ALUSrc(id_ALUsrc),.ID_MemtoReg(id_MemtoReg),.ID_RegWrite(id_RegWr),
    .ID_MemWrite(id_MemWr),.ID_Branch(id_Branch),.ID_nBranch(id_nBranch),
    .ID_BGEZ(id_BGEZ),.ID_BGTZ(id_BGTZ),.ID_BLEZ(id_BLEZ),.ID_BLTZ(id_BLTZ),
    .ID_lb(id_lb),.ID_lbu(id_lbu),.ID_sb(id_sb),.ID_jal(id_jal),.ID_jmp(id_jmp),
    .ID_jr(id_jr),.ID_jalr(id_jalr),.ID_ExtOp(id_ExtOp),.ID_ALUctr(id_ALUctr),.ID_shamt(id_shamt)
);

//ID/EX midreg
ID_EX reg_IDEX(
    .clk(clk),.ID_pc(id_pc),.ID_pc_plus4(id_pc_plus4),.ID_inst(id_inst),.ID_immExt(id_immExt),
    .ID_busA(id_busA),.ID_busB(id_busB),.ID_RegDST(id_RegDst),.ID_ALUSrc(id_ALUsrc),
    .ID_MemtoReg(id_MemtoReg),.ID_RegWrite(id_RegWr),.ID_Memwrite(id_MemWr),
    .ID_Branch(id_Branch),.ID_nBranch(id_nBranch),.ID_BGEZ(id_BGEZ),.ID_BGTZ(id_BGTZ),.ID_BLEZ(id_BLEZ),.ID_BLTZ(id_BLTZ),
    .ID_lb(id_lb),.ID_lbu(id_lbu),.ID_sb(id_sb),.ID_jal(id_jal),.ID_jmp(id_jmp),.ID_jr(id_jr),.ID_jalr(id_jalr),
    .ID_ALUctr(id_ALUctr),.ID_shamt(id_shamt),

    .EX_pc(ex_pc),.EX_pc_plus4(ex_pc_plus4),.EX_inst(ex_inst),.EX_immExt(ex_immEXt),
    .EX_busA(ex_busA),.EX_busB(ex_busB),
    .EX_ALUctr(ex_ALUctr),.EX_shamt(ex_shamt),.EX_RegDST(ex_RegDst),.EX_ALUSrc(ex_ALUsrc),
    .EX_MemtoReg(ex_MemtoReg),.EX_RegWrite(ex_RegWr),.EX_Memwrite(ex_MemWr),
    .EX_Branch(ex_Branch),.EX_nBranch(ex_nBranch),.EX_BGEZ(ex_BGEZ),.EX_BGTZ(ex_BGTZ),.EX_BLEZ(ex_BLEZ),.EX_BLTZ(ex_BLTZ),
    .EX_lb(ex_lb),.EX_lbu(ex_lbu),.EX_sb(ex_sb),.EX_jal(ex_jal),.EX_jmp(ex_Jmp),.EX_jr(ex_jr),.EX_jalr(ex_jalr)
);

//EX
EX EX_(
    .pc(ex_pc),.pc_plus4(ex_pc_plus4),.inst(ex_inst),.immExt(ex_immEXt),
    .busA(ex_busA),.busB(ex_busB),.ALUctr(ex_ALUctr),.shamt(ex_shamt),
    .RegDST(ex_RegDst),.ALUSrc(ex_ALUsrc),.MemtoReg(ex_MemtoReg),.RegWrite(ex_RegWr),.MemWrite(ex_MemWr),
    .Branch(ex_Branch),.nBranch(ex_nBranch),.BGEZ(ex_BGEZ),.BGTZ(ex_BGTZ),.BLEZ(ex_BLEZ),.BLTZ(ex_BLTZ),
    .lb(ex_lb),.lbu(ex_lbu),.sb(ex_sb),.jal(ex_jal),.jmp(ex_Jmp),.jr(ex_jr),.jalr(ex_jalr),

    .EX_pc(EX_pc),.EX_pc_plus4(EX_pc_plus4),.EX_inst(EX_inst),
    .EX_MemtoReg(EX_MemtoReg),.EX_RegWrite(EX_RegWr),.EX_Memwrite(EX_MemWr),.EX_lb(EX_lb),.EX_lbu(EX_lbu),.EX_sb(EX_sb),
    .EX_ALUresult(EX_alu_result),.EX_zero(EX_zero),.EX_npc(EX_npc),.EX_Rw(EX_Rw)
);

//EX/MEM midreg
EX_MEM reg_EXMEM(
    .clk(clk),.EX_pc(EX_pc),.EX_pc_plus4(EX_pc_plus4),.EX_npc(EX_npc),.EX_inst(EX_inst),
    .EX_busB(ex_busB),.EX_Rw(EX_Rw),
    .EX_ALUresult(EX_alu_result),.EX_zero(EX_zero),.EX_MemtoReg(EX_MemtoReg),.EX_MemWrite(EX_MemWr),.EX_RegWrite(EX_RegWr),
    .EX_Branch(ex_Branch),.EX_nBranch(ex_nBranch),.EX_BGEZ(ex_BGEZ),.EX_BGTZ(ex_BGTZ),.EX_BLEZ(ex_BLEZ),.EX_BLTZ(ex_BLTZ),
    .EX_lb(ex_lb),.EX_lbu(ex_lbu),.EX_sb(ex_sb),.EX_jal(ex_jal),.EX_jmp(ex_Jmp),

    .MEM_pc(mem_pc),.MEM_pc_plus4(mem_pc_plus4),.MEM_inst(mem_inst),
    .MEM_busB(mem_busB),.MEM_Rw(mem_Rw),.MEM_ALUresult(mem_alu_result),.MEM_npc(mem_npc),
    .MEM_zero(mem_zero),.MEM_MemtoReg(mem_MemtoReg),.MEM_MemWrite(mem_MemWr),.MEM_RegWrite(mem_RegWr),
    .MEM_Branch(mem_Branch),.MEM_nBranch(mem_nBranch),.MEM_BGEZ(mem_BGEZ),.MEM_BGTZ(mem_BGTZ),.MEM_BLEZ(mem_BLEZ),.MEM_BLTZ(mem_BLTZ),
    .MEM_lb(mem_lb),.MEM_lbu(mem_lbu),.MEM_sb(mem_sb),.MEM_jal(mem_jal),.MEM_jmp(mem_jmp)
);

//MEM
MEM MEM_(
    .clk(clk),
    .inst(mem_inst),
    .npc(mem_npc),
    .MemWrite(mem_MemWr),
    .dm_addr(mem_alu_result[11:0]),
    .busB(mem_busB),
    .sb(mem_sb),.lb(mem_lb),.lbu(mem_lbu),
    
    .dm_rdata(MEM_rdata),
    .mem_npc(MEM_npc)
);

//MEM/WR midreg
MEM_WR reg_MEMWR(
    .clk(clk),
    .MEM_pc(mem_pc),
    .MEM_pc_plus4(mem_pc_plus4),
    .MEM_inst(mem_inst),
    .MEM_dout(MEM_rdata),
    .MEM_ALUresult(mem_alu_result),
    .MEM_Rw(mem_Rw),
    .MEM_RegWrite(mem_RegWr),
    .MEM_MemtoReg(mem_MemtoReg),

    .WR_pc(WR_pc),
    .WR_pc_plus4(WR_pc_plus4),
    .WR_dout(WR_rdata),
    .WR_ALUresult(WR_alu_result),
    .WR_Rw(WR_Rw),
    .WR_RegWrite(WR_RegWr),
    .WR_MemtoReg(WR_MemtoReg)
);

//WR
WR WR_(
    .dm_rdata(WR_rdata),
    .ALUresult(WR_alu_result),
    .MemtoReg(WR_MemtoReg),

    .WR_busW(WR_busW)
);

endmodule