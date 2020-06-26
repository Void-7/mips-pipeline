module MEM(
    input clk,
    input [31:0]inst,
    //input [31:0]npc,
    input MemWrite,
    input [11:0]dm_addr,
    input [31:0]busB,
    input sb,lb,lbu,
    input jal,jalr,
    input ForwardD,
    input [31:0]C4,
    
    output [31:0]dm_rdata,
    //output [31:0]mem_npc,
    output mem_jal,mem_jalr
);
wire [31:0]real_busB;
//dm
dm_4k dm(sb,lb,lbu,dm_addr,real_busB,MemWrite,clk,dm_rdata);
assign real_busB=(ForwardD)?C4:busB;

//assign mem_npc=npc;
assign mem_jal=jal;
assign mem_jalr=jalr;
endmodule