module lut_2to3(
    input [1:0] sel,
    output reg [2:0] out
);
    always @(*) begin
        case (sel)
            2'b00: out = 3'b000; // impossible
            2'b01: out = 3'b010;
            2'b10: out = 3'b011;
            2'b11: out = 3'b100;
            default: out = 3'b000; // impossible
        endcase
    end
endmodule
