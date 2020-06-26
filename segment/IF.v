module IF(
    input[31:0] npc,
    input clk,rst,
    input pc_stall_en,  //allow pc to stall for a circle
    input Flush,

    output[31:0] inst,
    output[31:0] IF_pc,
    output[31:0] IF_pc_plus4
);
wire[31:0]next_pc;
wire[31:0]next_pc2;
wire[31:0]instruction;
PC pc(
    .clk(clk),.rst(rst),
    .input_data(next_pc2),
    .output_data(IF_pc)
);

assign next_pc2=(pc_stall_en)?IF_pc:next_pc;
assign next_pc=(npc!=32'hffff_ffff)?npc:IF_pc_plus4;

assign IF_pc_plus4=IF_pc+4;
im_4k im(IF_pc[11:2],instruction);
assign inst=(Flush)?32'b0:instruction;

endmodule