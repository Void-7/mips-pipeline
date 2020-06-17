module IF(
    input[31:0] npc,
    input clk,rst,
    
    output[31:0] inst,
    output[31:0] IF_pc,
    output[31:0] IF_pc_plus4
);
wire[31:0]next_pc;

PC pc(
    .clk(clk),.rst(rst),
    .input_data(next_pc),
    .output_data(IF_pc)
);

assign next_pc=(npc!=32'b0)?npc:IF_pc_plus4;

assign IF_pc_plus4=IF_pc+4;
im_4k im(IF_pc[11:2],inst);

endmodule