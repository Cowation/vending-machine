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
    wire [1:0] selection;
    wire [2:0] coins;
    wire [2:0] next_coins;
    wire [2:0] price;
    
    assign O = output_on ? selection : 2'b00;
    
    lut_2to3 price_lut (
        .sel (selection),
        .out (price)
    );

    reg2 selection_reg (
        .D (I),
        .load (select_load),
        .clear (clear),
        .clk (clk),
        .Q (selection)
    );

    add3 coins_incrementer (
        .A (coins),
        .B (3'b001),
        .sum (next_coins)
    );

    reg3 coins_reg (
        .D (next_coins),
        .load (coins_load),
        .clear (clear),
        .clk (clk),
        .Q (coins)
    );

    lt3 coins_price_comparator (
        .A (coins),
        .B (price),
        .lt (coins_lt_price)
    );
endmodule
