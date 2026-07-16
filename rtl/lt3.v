module lt3(
    input [2:0] A,
    input [2:0] B,
    output lt
);
    assign lt = A < B;
endmodule
