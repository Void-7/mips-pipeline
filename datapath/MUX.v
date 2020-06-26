module MUX(
    input[31:0]a,
    input[31:0]b,
    input switch,
    
    output reg[31:0]out
);

always@(*) begin
    if(switch)
        out<=b;
    else 
        out<=a;
end

endmodule

module MUX_3src_5bit(
    input[4:0]a,
    input[4:0]b,
    input[4:0]c,
    input b_enable,
    input c_enable,
    
    output reg[4:0]out
);

always@(*) begin
    if(b_enable)
        out<=b;
    else if(c_enable)
        out<=c;
    else out<=a;
end

endmodule

module MUX3#(parameter WIDTH = 5)
(
    input[WIDTH-1:0]a,
    input[WIDTH-1:0]b,
    input[WIDTH-1:0]c,
    input[1:0]switch,

    output reg[WIDTH-1:0]out
);

always@(*)begin
    case(switch)
    2'b00:out<=a;
    2'b01:out<=b;
    2'b10:out<=c;
    endcase
end

endmodule