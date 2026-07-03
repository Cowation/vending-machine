module controller(
    input clk,
    input grst,

    // External user input
    input [3:0] I,
    
    // Internal from datapath
    input coins_lt_price,
    
    // To datapath
    output clear,
    output select_load,
    output coins_load,
    output output_on
);
    reg [2:0] s;
    
    wire [2:0] n;
    
    assign n[2] = s[1] & ~s[0] & ~coins_lt_price;
    assign n[1] = s[0] | (s[1] & ~I[3] & coins_lt_price);
    assign n[0] = ~s[2] & ~s[0] & ((~s[1] & (I[1] | I[0])) | (s[1] & I[2] & ~I[3] & coins_lt_price));
    
    assign clear = ~s[2] & ~s[1] & ~s[0];
    assign select_load = ~s[1] & s[0];
    assign coins_load = s[1] & s[0];
    assign output_on = s[2];
    
    always @(posedge clk or posedge grst) begin
        if (grst) begin
            s <= 3'b000;
        end else begin
            s <= n;
        end
    end
endmodule