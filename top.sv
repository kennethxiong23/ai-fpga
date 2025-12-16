`include "memory.sv"
`include "relu.sv"
// `include "maxpool2d.sv"

module top #(
    parameter image_width = 5,
    parameter pooled_width = 3
)(
    input logic clk
);
    logic signed[image_width*image_width*32-1:0] input_image;
    // int test = 1000;
    // int output_test;
    int timer = 1000;
    logic relu_done;

    logic signed[image_width*image_width*32-1:0] test;
    logic [image_width*image_width*32-1:0] output_test;

    logic signed [pooled_width*pooled_width*32-1:0] pooled_output;

    memory #(
        .INIT_FILE      ("zero_padding.txt"),
        .image_width    (image_width)
    ) u1 (
        .read_data      (input_image)
    );
    relu #(
        .map_width       (image_width)
    ) relu (
        .clk             (clk),
        .input_map       (input_image),
        .output_map      (output_test),
        .done            (relu_done)
    );
    // max_pool2d #(
    //     .in_width(image_width),
    //     .out_width(pooled_width)
    // ) maxpool2d (
    //     .clk(clk),
    //     .in_map(input_image),
    //     .out_map(pooled_output)
    // );

    always_ff @(posedge clk) begin
        // test <= test -100;
        timer <= timer - 100;
    end


endmodule
