module WR(
    input [31:0]dm_rdata,
    input [31:0]ALUresult,
    input MemtoReg,
    input jal,jalr,
    input [31:0]pc_plus4,

    output [31:0]WR_busW
);

wire[31:0]wdata;
MUX regsrc_mux(ALUresult,dm_rdata,MemtoReg,wdata);
MUX jalr_mux(wdata,pc_plus4,(jalr||jal),WR_busW);//jalr mux for writing Rd

endmodule