module datapath(
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

endmodule