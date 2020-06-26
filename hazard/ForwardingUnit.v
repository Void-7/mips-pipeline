module ForwardingUnit(
    input[4:0]IDEX_Rs,
    input[4:0]IDEX_Rt,
    input[4:0]EXMEM_Rd,
    input[4:0]EXMEM_Rt,
    input[4:0]MEMWR_Rd,
    input[4:0]IDEX_Rd,
    input[4:0]IFID_Rs,
    input[4:0]IFID_Rt,
    input IFID_RegWr,
    input IDEX_RegWr,
    input IDEX_MemWr,
    input EXMEM_RegWr,
    input EXMEM_MemWr,
    input MEMWR_RegWr,

    output reg[1:0]ForwardA,
    output reg[1:0]ForwardB,
    output reg ForwardC,
    output reg ForwardD,
    output reg[1:0]ForwardE,
    output reg[1:0]ForwardF
);
wire C1a,C1b,C2a,C2b;wire C3a;wire C4;wire C6a,C6b;
assign C1a=(EXMEM_RegWr)&&(EXMEM_Rd!=5'b0)&&(EXMEM_Rd==IDEX_Rs);
assign C1b=(EXMEM_RegWr)&&(EXMEM_Rd!=5'b0)&&(EXMEM_Rd==IDEX_Rt)&&(!IDEX_MemWr);
assign C2a=(MEMWR_RegWr)&&(MEMWR_Rd!=5'b0)&&(EXMEM_Rd!=IDEX_Rs)
&&(MEMWR_Rd==IDEX_Rs)
||(MEMWR_RegWr)&&(MEMWR_Rd!=5'b0)&&(EXMEM_MemWr)&&(MEMWR_Rd==IDEX_Rs);
assign C2b=(MEMWR_RegWr)&&(MEMWR_Rd!=5'b0)&&(EXMEM_Rd!=IDEX_Rt)
&&(MEMWR_Rd==IDEX_Rt)
||(MEMWR_RegWr)&&(MEMWR_Rd!=5'b0)&&(EXMEM_MemWr)&&(MEMWR_Rd==IDEX_Rt);
assign C3a=(IDEX_RegWr)&&(IDEX_Rd!=5'b0)&&(IDEX_Rd==IFID_Rs);
assign C4=(EXMEM_MemWr)&&(MEMWR_Rd!=5'b0)&&(EXMEM_Rt==MEMWR_Rd);//sw pre-post data hazard
assign C5a=(EXMEM_RegWr)&&(EXMEM_Rd!=5'b0)&&(IFID_Rs==EXMEM_Rd);
assign C5b=(EXMEM_RegWr)&&(EXMEM_Rd!=5'b0)&&(IFID_Rt==EXMEM_Rd);
assign C6a=(IFID_RegWr)&&(MEMWR_Rd!=5'b0)&&(IFID_Rs==MEMWR_Rd);//for case that 2 insts divided by 2 insts
assign C6b=(IFID_RegWr)&&(MEMWR_Rd!=5'b0)&&(IFID_Rt==MEMWR_Rd);
always@(*)begin
    if(C1a) ForwardA=2'b10;
    else if(C2a) ForwardA=2'b01;
    else ForwardA=2'b00;

    if(C1b) ForwardB=2'b10;
    else if(C2b) ForwardB=2'b01;
    else ForwardB=2'b00;

    if(C3a) ForwardC=1;
    else ForwardC=0;

    if(C4) ForwardD=1;
    else ForwardD=0;

    if(C5a) ForwardE=2'b10;
    else if(C5b) ForwardE=2'b01;
    else ForwardE=2'b00;

    if(C6a) ForwardF=2'b10;
    else if(C6b) ForwardF=2'b01;
    else ForwardF=2'b00;
end

endmodule