module EX(
    input[31:0] pc,
    input[31:0] pc_plus4,
    input[31:0] inst,
    input[31:0] immExt,
    input[31:0] busA,
    input[31:0] busB,
    input[4:0] ALUctr,
    input[4:0] shamt,
    input[1:0] ForwardA,ForwardB,
    input[31:0] C1,C2,
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
    output EX_MemtoReg,
    output EX_RegWrite,
    output EX_Memwrite,
    output EX_lb,EX_lbu,EX_sb,
    output EX_jal,EX_jalr,
    output [31:0] EX_ALUresult,
    output EX_zero,
    output [4:0] EX_Rw

);
wire carry,overflow;
wire[31:0]ALUbusB;
wire[31:0]real_busA,real_busB;

//Forwarding MUX for ALU
MUX3#(32) af_mux1(busA,C2,C1,ForwardA,real_busA);
MUX3#(32) af_mux2(ALUbusB,C2,C1,ForwardB,real_busB);

//ALU
ALU alu(real_busA,real_busB,ALUctr,EX_ALUresult,shamt,EX_zero,carry,overflow);
MUX alusrc_mux(busB,immExt,ALUSrc,ALUbusB);

//WR MUX
wire [4:0]reg31=5'b11111;
MUX_3src_5bit wreg_mux(inst[20:16],inst[15:11],reg31[4:0],RegDST,jal,EX_Rw);


assign EX_pc=pc;
assign EX_pc_plus4=pc_plus4;
assign EX_inst=inst;
assign EX_MemtoReg=MemtoReg;
assign EX_RegWrite=RegWrite;
assign EX_Memwrite=MemWrite;
assign EX_lb=lb;
assign EX_lbu=lbu;
assign EX_sb=sb;
assign EX_jal=jal;
assign EX_jalr=jalr;
endmodule