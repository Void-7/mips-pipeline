module mips(
    input clk,
    input rst
);

wire[31:0] pc;
wire[31:0] pc_plus4;
wire[31:0]instruction;

wire[31:0] id_pc;
wire[31:0] id_pc_plus4;
wire[31:0] id_inst;
wire[31:0] id_busA;
wire[31:0] id_busB;
wire[31:0] id_immExt;
wire id_RegWr;
wire id_RegDst;
wire id_ALUsrc;
wire id_Branch,id_nBranch,id_BGEZ,id_BGTZ,id_BLTZ,id_BLEZ;
wire id_jmp,id_jal,id_jr,id_jalr;
wire id_lb,id_lbu,id_sb;
wire id_MemWr;
wire id_MemtoReg;
wire[31:0] ID_inst;
wire[31:0] ID_pc;
wire[31:0] ID_pc_plus4;
wire[4:0] id_ALUctr;
wire[4:0] id_shamt;

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
wire EX_jal,EX_jalr;
wire EX_MemWr;
wire EX_MemtoReg;
wire EX_zero;

wire[31:0]mem_pc;
wire[31:0]mem_pc_plus4;
wire[31:0]mem_inst;
wire[31:0]mem_busB;
wire[4:0]mem_Rw;
wire[31:0]mem_alu_result;
wire mem_MemtoReg,mem_MemWr;
wire mem_RegWr;
wire mem_Branch,mem_nBranch,mem_BGEZ,mem_BGTZ,mem_BLEZ,mem_BLTZ;
wire mem_lb,mem_lbu,mem_sb;
wire mem_jal,mem_jalr,mem_jmp;

wire[31:0]WR_pc;wire[31:0]WR_pc_plus4;
wire[31:0]WR_rdata;wire[31:0]WR_alu_result;
wire[4:0]WR_Rw;
wire WR_RegWr,WR_MemtoReg;
wire WR_jal,WR_jalr;
wire[31:0]WR_busW;

wire[31:0]MEM_rdata;
wire[31:0]ID_npc;
wire MEM_jal,MEM_jalr;

wire [1:0]ForwardA,ForwardB;wire ForwardC,ForwardD;
wire[1:0]ForwardE;wire[1:0]ForwardF;
wire pc_stall_en,IFID_Wr,IDEX_Clear;
wire FlushCondition;

//Hazard Solve
ForwardingUnit ForwardingUnit(
    .IDEX_Rs(ex_inst[25:21]),.IDEX_Rt(ex_inst[20:16]),.EXMEM_Rd(mem_Rw),.EXMEM_Rt(mem_inst[20:16]),
    .MEMWR_Rd(WR_Rw),.IDEX_Rd(ex_inst[15:11]),.IFID_Rs(id_inst[25:21]),.IFID_Rt(id_inst[20:16]),
    .IFID_RegWr(id_RegWr),.IDEX_RegWr(ex_RegWr),.IDEX_MemWr(ex_MemWr),.EXMEM_RegWr(mem_RegWr),.EXMEM_MemWr(mem_MemWr),.MEMWR_RegWr(WR_RegWr),

    .ForwardA(ForwardA),.ForwardB(ForwardB),.ForwardC(ForwardC),.ForwardD(ForwardD),.ForwardE(ForwardE),.ForwardF(ForwardF)
);

HazardDetectionUnit HazardDetectionUnit(
    .IFID_Rs(id_inst[25:21]),.IFID_Rt(id_inst[20:16]),.IDEX_Rt(ex_inst[20:16]),.IDEX_MemtoReg(ex_MemtoReg),

    .pc_stall_en(pc_stall_en),.IFID_Wr(IFID_Wr),.IDEX_Clear(IDEX_Clear)
);

//IF
IF IF_(
    .npc(ID_npc),.clk(clk),.rst(rst),.pc_stall_en(pc_stall_en),.Flush(FlushCondition),

    .inst(instruction),.IF_pc_plus4(pc_plus4),.IF_pc(pc)
);

//IF/ID midreg
IF_ID reg_IFID(
    .clk(clk),.pc(pc),.pc_plus4(pc_plus4),.inst(instruction),.IFID_Wr(IFID_Wr),.Flush(FlushCondition),

    .ID_pc(id_pc),.ID_pc_plus4(id_pc_plus4),.ID_inst(id_inst)
);

wire[31:0]id_C1;
assign id_C1=(mem_MemtoReg)?MEM_rdata:mem_alu_result;
//ID
ID ID_(
    .clk(clk),.rst(rst),.inst(id_inst),.wreg(WR_Rw),.Rs(id_inst[25:21]),.Rt(id_inst[20:16]),
    .pc(id_pc),.pc_plus4(id_pc_plus4),.wdata(WR_busW),.RegWrite(WR_RegWr),.IDEX_Clear(IDEX_Clear),.pc_stall_en(pc_stall_en),
    .ForwardC(ForwardC),.ForwardE(ForwardE),.ForwardF(ForwardF),.C3(EX_alu_result),.C1(id_C1),.C6(WR_alu_result),

    .real_ID_inst(ID_inst),.real_ID_npc(ID_npc),.real_ID_pc(ID_pc),.real_ID_pc_plus4(ID_pc_plus4),
    .real_ID_busA(id_busA),.real_ID_busB(id_busB),.real_ID_immExt(id_immExt),.real_ID_RegDST(id_RegDst),
    .real_ID_ALUSrc(id_ALUsrc),.real_ID_MemtoReg(id_MemtoReg),.real_ID_RegWrite(id_RegWr),
    .real_ID_MemWrite(id_MemWr),.real_ID_Branch(id_Branch),.real_ID_nBranch(id_nBranch),
    .real_ID_BGEZ(id_BGEZ),.real_ID_BGTZ(id_BGTZ),.real_ID_BLEZ(id_BLEZ),.real_ID_BLTZ(id_BLTZ),
    .real_ID_lb(id_lb),.real_ID_lbu(id_lbu),.real_ID_sb(id_sb),.real_ID_jal(id_jal),.real_ID_jmp(id_jmp),
    .real_ID_jr(id_jr),.real_ID_jalr(id_jalr),.real_ID_ALUctr(id_ALUctr),.real_ID_shamt(id_shamt),.ID_Flush(FlushCondition)
);

//ID/EX midreg
ID_EX reg_IDEX(
    .clk(clk),.ID_pc(ID_pc),.ID_pc_plus4(ID_pc_plus4),.ID_inst(ID_inst),.ID_immExt(id_immExt),
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
    .ForwardA(ForwardA),.ForwardB(ForwardB),.C1(mem_alu_result),.C2(WR_busW),//Forward Signals
    .RegDST(ex_RegDst),.ALUSrc(ex_ALUsrc),.MemtoReg(ex_MemtoReg),.RegWrite(ex_RegWr),.MemWrite(ex_MemWr),
    .Branch(ex_Branch),.nBranch(ex_nBranch),.BGEZ(ex_BGEZ),.BGTZ(ex_BGTZ),.BLEZ(ex_BLEZ),.BLTZ(ex_BLTZ),
    .lb(ex_lb),.lbu(ex_lbu),.sb(ex_sb),.jal(ex_jal),.jmp(ex_Jmp),.jr(ex_jr),.jalr(ex_jalr),

    .EX_pc(EX_pc),.EX_pc_plus4(EX_pc_plus4),.EX_inst(EX_inst),
    .EX_MemtoReg(EX_MemtoReg),.EX_RegWrite(EX_RegWr),.EX_Memwrite(EX_MemWr),.EX_lb(EX_lb),.EX_lbu(EX_lbu),.EX_sb(EX_sb),
    .EX_jal(EX_jal),.EX_jalr(EX_jalr),.EX_ALUresult(EX_alu_result),.EX_zero(EX_zero),.EX_Rw(EX_Rw)
);

//EX/MEM midreg
EX_MEM reg_EXMEM(
    .clk(clk),.EX_pc(EX_pc),.EX_pc_plus4(EX_pc_plus4),.EX_inst(EX_inst),
    .EX_busB(ex_busB),.EX_Rw(EX_Rw),
    .EX_ALUresult(EX_alu_result),.EX_MemtoReg(EX_MemtoReg),.EX_MemWrite(EX_MemWr),.EX_RegWrite(EX_RegWr),
    .EX_Branch(ex_Branch),.EX_nBranch(ex_nBranch),.EX_BGEZ(ex_BGEZ),.EX_BGTZ(ex_BGTZ),.EX_BLEZ(ex_BLEZ),.EX_BLTZ(ex_BLTZ),
    .EX_lb(ex_lb),.EX_lbu(ex_lbu),.EX_sb(ex_sb),.EX_jal(ex_jal),.EX_jalr(EX_jalr),.EX_jmp(ex_Jmp),

    .MEM_pc(mem_pc),.MEM_pc_plus4(mem_pc_plus4),.MEM_inst(mem_inst),
    .MEM_busB(mem_busB),.MEM_Rw(mem_Rw),.MEM_ALUresult(mem_alu_result),
    .MEM_MemtoReg(mem_MemtoReg),.MEM_MemWrite(mem_MemWr),.MEM_RegWrite(mem_RegWr),
    .MEM_Branch(mem_Branch),.MEM_nBranch(mem_nBranch),.MEM_BGEZ(mem_BGEZ),.MEM_BGTZ(mem_BGTZ),.MEM_BLEZ(mem_BLEZ),.MEM_BLTZ(mem_BLTZ),
    .MEM_lb(mem_lb),.MEM_lbu(mem_lbu),.MEM_sb(mem_sb),.MEM_jal(mem_jal),.MEM_jalr(mem_jalr),.MEM_jmp(mem_jmp)
);

//MEM
MEM MEM_(
    .clk(clk),
    .inst(mem_inst),
    .MemWrite(mem_MemWr),
    .dm_addr(mem_alu_result[11:0]),
    .busB(mem_busB),
    .sb(mem_sb),.lb(mem_lb),.lbu(mem_lbu),
    .jal(mem_jal),.jalr(mem_jalr),
    .ForwardD(ForwardD),.C4(WR_alu_result),
    
    .dm_rdata(MEM_rdata),
    .mem_jal(MEM_jal),.mem_jalr(MEM_jalr)
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
    .MEM_jal(MEM_jal),.MEM_jalr(MEM_jalr),

    .WR_pc(WR_pc),
    .WR_pc_plus4(WR_pc_plus4),
    .WR_dout(WR_rdata),
    .WR_ALUresult(WR_alu_result),
    .WR_Rw(WR_Rw),
    .WR_RegWrite(WR_RegWr),
    .WR_MemtoReg(WR_MemtoReg),
    .WR_jal(WR_jal),.WR_jalr(WR_jalr)
);

//WR
WR WR_(
    .dm_rdata(WR_rdata),
    .ALUresult(WR_alu_result),
    .MemtoReg(WR_MemtoReg),
    .jal(WR_jal),.jalr(WR_jalr),
    .pc_plus4(WR_pc_plus4),

    .WR_busW(WR_busW)
);

endmodule