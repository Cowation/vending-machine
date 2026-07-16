(* extract_order = -1 *)
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

(* extract_order = -2 *)
module AND2_X1 (
    input A,
    input B,
    output Y
);
    assign Y = A & B;
endmodule

(* extract_order = -3 *)
module AND3_X1 (
    input A,
    input B,
    input C,
    output Y
);
    assign Y = A & B & C;
endmodule

(* extract_order = -4 *)
module AND4_X1 (
    input A,
    input B,
    input C,
    input D,
    output Y
);
    assign Y = A & B & C & D;
endmodule

(* extract_order = -2 *)
module OR2_X1 (
    input A,
    input B,
    output Y
);
    assign Y = A | B;
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
