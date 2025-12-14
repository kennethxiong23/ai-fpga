nodule top(
    input logic clk,
)
    logic [783:0] input_image;
    memory #(
        .INIT_FILE      ("input.txt")
    ) u1 (
        .read_data      (input_image)
    );
