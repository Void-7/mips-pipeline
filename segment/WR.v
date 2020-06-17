module WR(
    input [31:0]dm_rdata,
    input [31:0]ALUresult,
    input MemtoReg,

    output [31:0]WR_busW
);

MUX regsrc_mux(ALUresult,dm_rdata,MemtoReg,WR_busW);

endmodule