`timescale 1ns / 1ps

module top_tb;
    reg clk;
    reg grst;
    reg [3:0] I;

    wire [1:0] O;

    integer errors;

    top dut (
        .clk (clk),
        .grst (grst),
        .I (I),
        .O (O)
    );

    initial begin
        clk = 1'b0;
    end

    always begin
        #5 clk = ~clk;
    end

    task tick;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task expect_o;
        input [1:0] expected;
        input [8*80-1:0] label;
        begin
            if (O !== expected) begin
                errors = errors + 1;
                $display("FAIL: %0s expected O=%b, got O=%b at %0t",
                         label, expected, O, $time);
            end else begin
                $display("PASS: %0s O=%b at %0t", label, O, $time);
            end
        end
    endtask

    task reset_dut;
        begin
            I = 4'b0000;
            grst = 1'b1;
            repeat (2) tick;
            grst = 1'b0;
            tick;
            expect_o(2'b00, "reset leaves machine idle");
        end
    endtask

    task start_order;
        input [1:0] selection;
        begin
            I = {2'b00, selection};
            tick;
            expect_o(2'b00, "order request does not ship");

            I = {2'b00, selection};
            tick;
            expect_o(2'b00, "selection load does not ship");

            I = 4'b0000;
            tick;
            expect_o(2'b00, "machine waits for coins after order");
        end
    endtask

    task insert_coin_no_vend;
        begin
            I = 4'b0100;
            tick;
            expect_o(2'b00, "coin pulse accepted without shipment");

            I = 4'b0000;
            tick;
            expect_o(2'b00, "coin counted below price");
        end
    endtask

    task insert_final_coin;
        input [1:0] shipment;
        begin
            I = 4'b0100;
            tick;
            expect_o(2'b00, "final coin pulse accepted");

            I = 4'b0000;
            tick;
            expect_o(2'b00, "final coin counted");

            tick;
            expect_o(shipment, "shipment is issued after enough coins");

            tick;
            expect_o(2'b00, "shipment lasts one cycle");

            tick;
            expect_o(2'b00, "machine returns to idle after shipment");
        end
    endtask

    task refund_to_idle;
        begin
            I = 4'b1000;
            tick;
            expect_o(2'b00, "refund request does not ship");

            I = 4'b0000;
            tick;
            expect_o(2'b00, "refund returns machine toward idle");

            tick;
            expect_o(2'b00, "machine is idle after refund");
        end
    endtask

    task test_tall;
        begin
            reset_dut;
            start_order(2'b01);
            insert_coin_no_vend;
            insert_final_coin(2'b01);
        end
    endtask

    task test_grand;
        begin
            reset_dut;
            start_order(2'b10);
            insert_coin_no_vend;
            insert_coin_no_vend;
            insert_final_coin(2'b10);
        end
    endtask

    task test_venti;
        begin
            reset_dut;
            start_order(2'b11);
            insert_coin_no_vend;
            insert_coin_no_vend;
            insert_coin_no_vend;
            insert_final_coin(2'b11);
        end
    endtask

    task test_reset_is_synchronous;
        begin
            reset_dut;
            start_order(2'b01);
            insert_coin_no_vend;

            I = 4'b0100;
            tick;
            expect_o(2'b00, "final coin pulse accepted before sync reset check");

            I = 4'b0000;
            tick;
            expect_o(2'b00, "final coin counted before sync reset check");

            tick;
            expect_o(2'b01, "machine is actively shipping before sync reset check");

            grst = 1'b1;
            #1;
            expect_o(2'b01, "synchronous reset waits for rising clock edge");

            tick;
            expect_o(2'b00, "synchronous reset clears machine on rising clock edge");

            grst = 1'b0;
            tick;
            expect_o(2'b00, "machine stays idle after synchronous reset release");
        end
    endtask

    task test_coins_before_order_ignored;
        begin
            reset_dut;

            I = 4'b0100;
            tick;
            expect_o(2'b00, "coin before order is ignored");

            I = 4'b0000;
            tick;
            expect_o(2'b00, "machine remains idle after ignored coin");

            start_order(2'b01);
            insert_coin_no_vend;

            tick;
            expect_o(2'b00, "ignored coin did not count toward Tall price");

            insert_final_coin(2'b01);
        end
    endtask

    task test_refund_clears_partial_order;
        begin
            reset_dut;

            start_order(2'b11);
            insert_coin_no_vend;
            insert_coin_no_vend;
            refund_to_idle;

            start_order(2'b01);
            insert_coin_no_vend;

            tick;
            expect_o(2'b00, "refunded coins did not count toward new order");

            insert_final_coin(2'b01);
        end
    endtask

    initial begin
        grst = 1'b0;
        I = 4'b0000;
        errors = 0;

        test_tall;
        test_grand;
        test_venti;
        test_reset_is_synchronous;
        test_coins_before_order_ignored;
        test_refund_clears_partial_order;

        if (errors == 0) begin
            $display("PASS: all vending machine tests passed");
        end else begin
            $display("FAIL: %0d vending machine test(s) failed", errors);
        end

        $finish;
    end

    initial begin
        #10000;
        $display("FAIL: simulation timed out");
        $finish;
    end

endmodule
