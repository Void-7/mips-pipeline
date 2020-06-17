module MEM(
    input clk,
    input [31:0]inst,
    input [31:0]npc,
    input MemWrite,
    input [11:0]dm_addr,
    input [31:0]busB,
    input sb,lb,lbu,
    
    output [31:0]dm_rdata,
    output [31:0]mem_npc
);

//dm
dm_4k dm(sb,lb,lbu,dm_addr,busB,MemWrite,clk,dm_rdata);

assign mem_npc=npc;

endmodule