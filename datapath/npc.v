module npc(
    input [31:0] cur_pc,    //pc
    //input [31:0] pc_next,   //pc+4
    input [31:0] rdata1,rdata2,//rf read data
    input [31:0] br_offset_words, //branch offset*4
    input [25:0] instruction,//for jmp_pc_addr
    input jmp,jr,jalr,jal,
    input Branch,nBranch,BGEZ,BGTZ,BLEZ,BLTZ,
    input [31:0] jf_data,
    input pc_stall_en,//for case that load-use with br/j-type inst behind
    
    output reg[31:0] jr_pc_addr,
    output FlushCondition
);
wire br_ctr;
reg[31:0] br_out;
wire[31:0] br_offset;
wire[31:0] bj_mux_result;
wire[31:0] jmp_pc_addr;
wire bgez,blez,bgtz,bltz;
reg Br_Condition;

wire signed [31:0] signed_a=rdata1,signed_b=rdata2;

wire[3:0]bgbl={BGEZ,BGTZ,BLEZ,BLTZ};
always@(*)begin
    case(bgbl)
    4'd8:Br_Condition=signed_a>=0?1:0;
    4'd4:Br_Condition=signed_a>0?1:0;
    4'd2:Br_Condition=signed_a<=0?1:0;
    4'd1:Br_Condition=signed_a<0?1:0;
    endcase
end

assign bgez=(BGEZ==1)?Br_Condition:1'b0;
assign bgtz=(BGTZ==1)?Br_Condition:1'b0;
assign blez=(BLEZ==1)?Br_Condition:1'b0;
assign bltz=(BLTZ==1)?Br_Condition:1'b0;

assign zero=(rdata1==rdata2);

assign br_offset=br_offset_words<<2;

//br-type inst.
assign br_ctr=(((Branch&zero&!nBranch&&!BGEZ&&!BGTZ&&!BLEZ&&!BLTZ)||(nBranch&&!zero)||bgez||bgtz||blez||bltz)&&(!pc_stall_en))?1'b1:1'b0;
always@(*) begin
    if(br_ctr) br_out<=cur_pc+br_offset;
    else br_out<=32'hffff_ffff;
end

//jmp-type inst.
assign jmp_pc_addr=(jmp==1)?({cur_pc[31:28],instruction[25:0],2'b00}+32'h00003000):32'b0;
MUX bj_mux(br_out,jmp_pc_addr,jmp,bj_mux_result);
always@(*) begin
    if(jr==1||jalr==1) jr_pc_addr<=jf_data+32'h00003000;
    else jr_pc_addr<=bj_mux_result;
end

assign FlushCondition=(br_ctr||jmp||jalr||jal||jr)&&(!pc_stall_en);


endmodule