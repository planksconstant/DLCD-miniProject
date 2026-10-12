`timescale 1ns / 1ps

module tb_serial_adder;
    reg clk;
    reg rst;
    reg start;
    reg [15:0] a_in;
    reg [15:0] b_in;
    
    wire [15:0] sum_out;
    wire cout_final;
    wire done;

    wire [16:0] full_result;
    assign full_result = {cout_final, sum_out};

    serial_adder_16bit uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a_in(a_in),
        .b_in(b_in),
        .sum_out(sum_out),
        .cout_final(cout_final),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_serial_adder.vcd");
        $dumpvars(0, tb_serial_adder);

        $display("-------------------------------------------------------------------------");
        $display("Time  | Start |  A (Hex)  |  B (Hex)  |  Sum (Hex)  | Cout | Complete?");
        $display("-------------------------------------------------------------------------");
        $monitor("%4t  |   %b   |   %h    |   %h    |    %h     |  %b   |    %b", 
                 $time, start, a_in, b_in, sum_out, cout_final, done);

        clk   = 0;
        rst   = 1;
        start = 0;
        a_in  = 16'h0000;
        b_in  = 16'h0000;

        #20;
        rst = 0;

        #10;
        a_in  = 16'h0005;
        b_in  = 16'h0003;
        start = 1;
        #10;
        start = 0;

        @(posedge done);
        #10;

        a_in  = 16'h1234;
        b_in  = 16'h0FED;
        start = 1;
        #10;
        start = 0;

        @(posedge done);
        #10;

        a_in  = 16'hFFFF;
        b_in  = 16'h0001;
        start = 1;
        #10;
        start = 0;

        @(posedge done);
        #20;

        $finish;
    end
endmodule
