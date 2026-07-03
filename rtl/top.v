module top(
    input clk,
    input grst,
    
    input [3:0] I,
    
    output [1:0] O
);
    wire clear;
    wire select_load;
    wire coins_load;
    wire output_on;
    
    wire coins_lt_price;
    
    controller vending_controller(
        .clk (clk),
        .grst (grst),
        .I (I),
        .coins_lt_price (coins_lt_price),
        .clear (clear),
        .select_load (select_load),
        .coins_load (coins_load),
        .output_on (output_on)
    );
    
    datapath vending_datapath(
        .clk (clk),
        .I (I),
        .clear (clear),
        .select_load (select_load),
        .coins_load (coins_load),
        .output_on (output_on),
        .coins_lt_price (coins_lt_price),
        .O (O)
    );
endmodule