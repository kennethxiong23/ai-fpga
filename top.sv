`include "memory.sv"
`include "relu.sv"
`include "maxpool2d.sv"

module top #(
    parameter image_width = 5,
    parameter pooled_width = 3
)(
    input logic clk
);
    logic signed[image_width*image_width*32-1:0] input_image;
    int test = 100;
    int output_test;
    logic signed [pooled_width*pooled_width*32-1:0] pooled_output;
    

    memory #(
        .INIT_FILE      ("zero_padding.txt")
    ) u1 (
        .read_data      (input_image)
    );
    relu  relu(
        .in_relu(test),
        .out_relu(output_test)
    );
    max_pool2d #(
        .in_width(image_width),
        .out_width(pooled_width)
    ) maxpool2d (
        .clk(clk),
        .in_map(input_image),
        .out_map(pooled_output)
    );

    always_ff @(posedge clk) begin
        test <= test -100;
    end


endmodule
