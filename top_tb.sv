`timescale 10ns/10ns
`include "top.sv"

module ai_fpga_tb;

    logic clk = 0;
    top u0 (
        .clk            (clk)
    );

    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, ai_fpga_tb);
        #100000
        $finish;
    end

    always begin
        #4
        clk = ~clk;
    end

endmodule

