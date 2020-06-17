module ID(
    input clk,rst,
    input [31:0] inst,
    input [4:0] wreg,
    input [4:0] Rs,
    input [4:0] Rt,
    input [31:0] wdata,
    input RegWrite,
    input [15:0] imm16,

    output [31:0] ID_busA,
    output [31:0] ID_busB,
    output [31:0] ID_immExt,
    output ID_RegDST,
    output ID_ALUSrc,
    output ID_MemtoReg,
    output ID_RegWrite,
    output ID_MemWrite,
    output ID_Branch,ID_nBranch,ID_BGEZ,ID_BGTZ,ID_BLEZ,ID_BLTZ,
    output ID_lb,ID_lbu,ID_sb,
    output ID_jal,ID_jmp,ID_jr,ID_jalr,
    output ID_ExtOp,
    output [4:0] ID_ALUctr,
    output [4:0] ID_shamt
);
wire Sftmd;
wire R_format;
wire [4:0] aluc;
wire [4:0] ALUop;
wire[31:0]extend,zextend;

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



endmodule