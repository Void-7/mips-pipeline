module EX(
    input[31:0] pc,
    input[31:0] pc_plus4,
    input[31:0] inst,
    input[31:0] immExt,
    input[31:0] busA,
    input[31:0] busB,
    input[4:0] ALUctr,
    input[4:0] shamt,
    input RegDST,
    input ALUSrc,
    input MemtoReg,
    input RegWrite,
    input MemWrite,
    input Branch,nBranch,BGEZ,BGTZ,BLEZ,BLTZ,
    input lb,lbu,sb,
    input jal,jmp,jr,jalr,

    output [31:0] EX_pc,
    output [31:0] EX_pc_plus4,
    output [31:0] EX_inst,
    //output reg[31:0] EX_immExt,
    //output reg[31:0] EX_busA,
    //output reg[31:0] EX_busB,
    //output reg[4:0] EX_ALUctr,
    //output reg[4:0] EX_shamt
    //output reg EX_RegDST,
    //output reg EX_ALUSrc,
    output EX_MemtoReg,
    output EX_RegWrite,
    output EX_Memwrite,
    //output reg EX_Branch,EX_nBranch,EX_BGEZ,EX_BGTZ,EX_BLEZ,EX_BLTZ,
    output EX_lb,EX_lbu,EX_sb,
    //output reg EX_jal,//EX_jmp,
    output [31:0] EX_ALUresult,
    output EX_zero,
    output [31:0] EX_npc,
    output [4:0] EX_Rw

);
wire carry,overflow;
wire[31:0]ALUbusB;
//ALU
ALU alu(busA,ALUbusB,ALUctr,EX_ALUresult,shamt,EX_zero,carry,overflow);
MUX alusrc_mux(busB,immExt,ALUSrc,ALUbusB);

//WR MUX
wire [4:0]reg31=5'b11111;
MUX_3src_5bit wreg_mux(inst[20:16],inst[15:11],reg31[4:0],RegDST,jal,EX_Rw);

//NPC
wire[31:0] sign_ext_offset,extend;
npc npc(pc,sign_ext_offset,inst[25:0],EX_ALUresult,jmp,jr,jalr,
Branch,EX_zero,nBranch,BGEZ,BGTZ,BLEZ,BLTZ,EX_npc);
s_ext BGL_mux(inst[15:0],extend);
assign sign_ext_offset=(Branch==1)?extend:32'b0;


assign EX_pc=pc;
assign EX_pc_plus4=pc_plus4;
assign EX_inst=inst;
assign EX_MemtoReg=MemtoReg;
assign EX_RegWrite=RegWrite;
assign EX_Memwrite=MemWrite;
assign EX_lb=lb;
assign EX_lbu=lbu;
assign EX_sb=sb;
endmodule