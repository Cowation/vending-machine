module reg2(
    input [1:0] D,
    input load,
    input clear,
    input clk,
    output reg [1:0] Q
);
    always @(posedge clk) begin
        if (clear) begin
            Q <= 2'b00;
        end else if (load) begin
            Q <= D;
        end
    end
endmodule
