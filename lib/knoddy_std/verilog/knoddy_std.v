module INV_X1 (
    input A,
    output Y
);
    assign Y = ~A;
endmodule

module BUF_X1 (
    input A,
    output Y
);
    assign Y = A;
endmodule

module NAND2_X1 (
    input A,
    input B,
    output Y
);
    assign Y = ~(A & B);
endmodule

module NOR2_X1 (
    input A,
    input B,
    output Y
);
    assign Y = ~(A | B);
endmodule

module MUX2_X1 (
    input A,
    input B,
    input S,
    output Y
);
    assign Y = S ? B : A;
endmodule

module DFF_X1 (
    input D,
    input CLK,
    output reg Q
);
    always @(posedge CLK) begin
        Q <= D;
    end
endmodule
