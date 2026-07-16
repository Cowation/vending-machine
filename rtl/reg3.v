module reg3(
    input [2:0] D,
    input load,
    input clear,
    input clk,
    output reg [2:0] Q
);
    always @(posedge clk) begin
        if (clear) begin
            Q <= 3'b000;
        end else if (load) begin
            Q <= D;
        end
    end
endmodule
