module datapath(
    input clk,

    // External user input
    input [1:0] I,
    
    // Internal from controller
    input clear,
    input select_load,
    input coins_load,
    input output_on,
    
    // To controller
    output coins_lt_price,
    
    output [1:0] O
);
    reg [1:0] selection;
    reg [2:0] coins;
    
    wire [2:0] price;
    
    assign O = output_on ? selection : 2'b00;
    
    lut_2to3 price_lut (
        .sel (selection),
        .out (price)
    );
    
    assign coins_lt_price = coins < price;
    
    always @(posedge clk) begin
        if (clear) begin
            selection <= 2'b00;
            coins <= 3'b000;
        end else begin
            if (select_load) begin
                selection <= I;
            end
            
            if (coins_load) begin
                coins <= coins + 3'b001;
            end
        end
    end
endmodule