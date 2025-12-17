module conv2d #(
    parameter int kernel_size,
    parameter int weight_width,
    parameter int stride,
    parameter int input_width,
    parameter int output_width
)(
    input  logic clk,
    input  logic reset,
    input  logic signed[kernel_size*kernel_size*weight_width-1:0] filter,
    input  logic signed [input_width*input_width*32-1:0]    input_image,
    output logic signed [output_width*output_width*32-1:0]  output_image,
    output logic done
);

    int output_x;
    int output_y;

    logic signed [63:0] kernel_sum;
    logic signed [63:0] weighted_val;

    int base_x;
    int base_y;

    int input_x;
    int input_y;

    initial begin
        output_x = 0;
        output_y = 0;
    end

    always_comb begin
        kernel_sum  = 64'sd0;
        weighted_val = 64'sd0;

        base_x = output_x * stride;
        base_y = output_y * stride;

        for (int ky = 0; ky < kernel_size; ky++) begin
            for (int kx = 0; kx < kernel_size; kx++) begin

                int input_x = base_x + kx;
                int input_y = base_y + ky;

                if (input_x < 0 || input_x >= input_width || input_y < 0 || input_y >= input_width) begin
                    weighted_val = 64'b0;
                end else begin
                    weighted_val = $signed(input_image[(input_y*input_width + input_x)*32 +: 32]) * $signed(filter[(ky*kernel_size + kx)*weight_width +: weight_width]);
                end

                kernel_sum += weighted_val;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            output_x <= 0;
            output_y <= 0;
            done     <= 0;
            output_image <= '0;
        end else begin

            if (!done) begin
                output_image[(output_y*output_width + output_x)*32 +: 32] <= kernel_sum[31:0];

                if (output_x == output_width-1) begin
                    output_x <= 0;
                    if (output_y == output_width-1) begin
                        output_y <= 0;
                        done <= 1;
                    end else begin
                        output_y <= output_y + 1;
                    end
                end else begin
                    output_x <= output_x + 1;
                end
            end

        end
    end

endmodule
