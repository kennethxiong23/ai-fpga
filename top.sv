`include "memory.sv"

module top(
    input logic clk
);
    logic [6271:0] input_image;

    memory #(
        .INIT_FILE      ("image.txt")
    ) u1 (
        .read_data      (input_image)
    );

endmodule
