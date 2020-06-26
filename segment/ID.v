module ID(
    input clk,rst,
    input [31:0] inst,
    input [4:0] wreg,
    input [4:0] Rs,
    input [4:0] Rt,
    input [31:0] pc,
    input [31:0] pc_plus4,
    input [31:0] wdata,
    input RegWrite,
    input IDEX_Clear,
    input pc_stall_en,
    input ForwardC,
    input [1:0] ForwardE,
    input [1:0] ForwardF,
    input [31:0] C3,
    input [31:0] C1,
    input [31:0] C6,

    output [31:0] real_ID_npc,
    output [31:0] real_ID_inst,
    output [31:0] real_ID_pc,
    output [31:0] real_ID_pc_plus4,
    output [31:0] real_ID_busA,
    output [31:0] real_ID_busB,
    output [31:0] real_ID_immExt,
    output real_ID_RegDST,
    output real_ID_ALUSrc,
    output real_ID_MemtoReg,
    output real_ID_RegWrite,
    output real_ID_MemWrite,
    output real_ID_Branch,real_ID_nBranch,real_ID_BGEZ,real_ID_BGTZ,real_ID_BLEZ,real_ID_BLTZ,
    output real_ID_lb,real_ID_lbu,real_ID_sb,
    output real_ID_jal,real_ID_jmp,real_ID_jr,real_ID_jalr,
    output [4:0] real_ID_ALUctr,
    output [4:0] real_ID_shamt,
    output ID_Flush
);
wire Sftmd;
wire ID_ExtOp;
wire R_format;
wire [4:0] aluc;
wire [4:0] ALUop;
wire [31:0]extend;wire[31:0]zextend;
wire [31:0]ID_npc;
wire [31:0]ID_busA;wire[31:0]ID_busB;wire[31:0]ID_immExt;
wire [4:0]ID_ALUctr;wire[4:0]ID_shamt;
wire ID_ALUSrc,ID_MemtoReg,ID_RegWrite,
ID_MemWrite,ID_Branch,ID_nBranch,ID_BGEZ,ID_BGTZ,ID_BLEZ,ID_BLTZ,
ID_lb,ID_lbu,ID_sb,ID_jmp,ID_jal,ID_jr,ID_jalr;
wire[31:0]bf_rdata1;wire[31:0]bf_rdata2;
wire[31:0]read_Rs;wire[31:0]read_Rt;
//GPR register file
regfile rf(
    .clk(clk),.rst(rst),
    .we(RegWrite),
    .raddr1(Rs),.raddr2(Rt),
    .waddr(wreg),
    .wdata(wdata),
    
    .rdata1(ID_busA),.rdata2(ID_busB)
);

//imm ext(0:zero_ext 1:sign_ext)
s_ext sext(inst[15:0],extend);
z_ext zext(inst[15:0],zextend);
assign ID_immExt=(ID_ExtOp==1)?extend:zextend;

//control, ALUcontrol
control ctl(
    .op(inst[31:26]),.br_div(inst[20:16]),

    .R_format(R_format),
    .RegDST(ID_RegDST),.ALUSrc(ID_ALUSrc),.MemtoReg(ID_MemtoReg),
    .RegWrite(ID_RegWrite),.MemWrite(ID_MemWrite),.Branch(ID_Branch),
    .nBranch(ID_nBranch),.BGEZ(ID_BGEZ),.BGTZ(ID_BGTZ),.BLEZ(ID_BLEZ),
    .BLTZ(ID_BLTZ),.lb(ID_lb),.lbu(ID_lbu),.sb(ID_sb),.jal(ID_jal),
    .Jmp(ID_jmp),.ExtOp(ID_ExtOp),.ALUop(ALUop)
);
ALUctl alu_ctl(
    .func(inst[5:0]),
    .R_Type(R_format),

    .aluc(aluc),
    .sftmd(Sftmd),
    .jr_out(ID_jr),.jalr_out(ID_jalr)
);

assign ID_ALUctr=(R_format==1)?aluc:ALUop;

assign ID_shamt=(Sftmd==1)?inst[10:6]:5'b00000;
wire[31:0] real_bf_rdata1,real_bf_rdata2;
//NPC
wire[31:0] sign_ext_offset;wire[31:0] jf_data;
npc npc(pc,read_Rs,read_Rt,sign_ext_offset,inst[25:0],ID_jmp,ID_jr,ID_jalr,ID_jal,
ID_Branch,ID_nBranch,ID_BGEZ,ID_BGTZ,ID_BLEZ,ID_BLTZ,real_bf_rdata1,pc_stall_en,
ID_npc,ID_Flush);
assign sign_ext_offset=(ID_Branch==1)?extend:32'b0;

//Forwarding slect for J-type inst
//assign jf_data=(ForwardC)?C3:bf_rdata1;

//Forwarding slect for Br-type inst:RAW
assign bf_rdata1=(ForwardE==2'b10)?C1:ID_busA;
assign bf_rdata2=(ForwardE==2'b01)?C1:ID_busB;
assign real_bf_rdata1=(ForwardC)?C3:bf_rdata1;

assign read_Rs=(ForwardF==2'b10)?C6:real_bf_rdata1;
assign read_Rt=(ForwardF==2'b01)?C6:bf_rdata2;

//assign real_bf_rdata2=(ForwardC)?C3:bf_rdata2;

//for load-use stall ID/EX midreg
IDEX_SigMux IDEX_SigMux(
    .IDEX_Clear(IDEX_Clear),.ID_pc(pc),.ID_pc_plus4(pc_plus4),.ID_npc(ID_npc),.ID_inst(inst),.ID_immExt(ID_immExt),
    .ID_busA(read_Rs),.ID_busB(read_Rt),.ID_RegDST(ID_RegDST),.ID_ALUSrc(ID_ALUSrc),
    .ID_MemtoReg(ID_MemtoReg),.ID_RegWrite(ID_RegWrite),.ID_Memwrite(ID_MemWrite),
    .ID_Branch(ID_Branch),.ID_nBranch(ID_nBranch),.ID_BGEZ(ID_BGEZ),.ID_BGTZ(ID_BGTZ),.ID_BLEZ(ID_BLEZ),.ID_BLTZ(ID_BLTZ),
    .ID_lb(ID_lb),.ID_lbu(ID_lbu),.ID_sb(ID_sb),.ID_jal(ID_jal),.ID_jmp(ID_jmp),.ID_jr(ID_jr),.ID_jalr(ID_jalr),
    .ID_ALUctr(ID_ALUctr),.ID_shamt(ID_shamt),

    .real_ID_pc(real_ID_pc),.real_ID_pc_plus4(real_ID_pc_plus4),.real_ID_npc(real_ID_npc),.real_ID_inst(real_ID_inst),.real_ID_immExt(real_ID_immExt),
    .real_ID_busA(real_ID_busA),.real_ID_busB(real_ID_busB),
    .real_ID_ALUctr(real_ID_ALUctr),.real_ID_shamt(real_ID_shamt),.real_ID_RegDST(real_ID_RegDST),.real_ID_ALUSrc(real_ID_ALUSrc),
    .real_ID_MemtoReg(real_ID_MemtoReg),.real_ID_RegWrite(real_ID_RegWrite),.real_ID_Memwrite(real_ID_MemWrite),
    .real_ID_Branch(real_ID_Branch),.real_ID_nBranch(real_ID_nBranch),.real_ID_BGEZ(real_ID_BGEZ),.real_ID_BGTZ(real_ID_BGTZ),.real_ID_BLEZ(real_ID_BLEZ),.real_ID_BLTZ(real_ID_BLTZ),
    .real_ID_lb(real_ID_lb),.real_ID_lbu(real_ID_lbu),.real_ID_sb(real_ID_sb),.real_ID_jal(real_ID_jal),.real_ID_jmp(real_ID_jmp),.real_ID_jr(real_ID_jr),.real_ID_jalr(real_ID_jalr)
);

endmodule