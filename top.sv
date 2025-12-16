`include "memory.sv"
`include "conv2d.sv"
`include "relu.sv"
`include "maxpool2d.sv"

module top #(
    parameter image_width = 5,
    parameter pooled_width = 3,
    parameter kernel_width = 3,
    parameter stride = 2,
    parameter filtered_width = 2
)(
    input logic clk
);
    logic relu_reset = 0;
    logic max_pool_reset = 0;
    logic conv_reset = 0;

    logic signed[image_width*image_width*32-1:0] input_image;
    
    logic relu_done;
    logic max_pool_done;
    logic conv_done;

    logic signed [filtered_width*filtered_width*32-1:0] filtered_output;
    logic [image_width*image_width*32-1:0] relu_output;
    logic signed [pooled_width*pooled_width*32-1:0] pooled_output;

    logic [kernel_width*kernel_width-1:0] filter;

    initial begin
        filter = 9'b101010101;
    end

    memory #(
        .INIT_FILE      ("zero_padding.txt"),
        .image_width    (image_width)
    ) u1 (
        .read_data      (input_image)
    );
    conv2d #(
        .kernel_size    (kernel_width),
        .stride         (stride),
        .input_width    (image_width),
        .output_width   (filtered_width)
    ) conv2d (
        .clk            (clk),
        .reset          (conv_reset),
        .filter         (filter),
        .input_image    (input_image),
        .output_image   (filtered_output),
        .done           (conv_done)
    );
    relu #(
        .map_width       (image_width)
    ) relu (
        .reset           (relu_reset),
        .clk             (clk),
        .input_map       (input_image),
        .output_map      (relu_output),
        .done            (relu_done)
    );
    max_pool2d #(
        .in_width(image_width),
        .out_width(pooled_width)
    ) maxpool2d (
        .clk(clk),
        .reset(max_pool_reset),
        .in_map(input_image),
        .out_map(pooled_output),
        .done (max_pool_done)
    );


endmodule
