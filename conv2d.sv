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

    int output_x = 0;
    int output_y = 0;

    logic signed [31:0] kernel_sum;
    logic signed [31:0] weighted_val;

    initial begin
        done = 0;
    end

    always_comb begin
        kernel_sum  = 31'sd0;
        weighted_val = 31'sd0;

        for (int ky = 0; ky < kernel_size; ky++) begin
            for (int kx = 0; kx < kernel_size; kx++) begin

                if (
                    (stride*output_x+ kx < 0) || 
                    (stride*output_x+ kx >= input_width) || 
                    (stride*output_y + ky < 0) || 
                    (stride*output_y + ky >= input_width)
                    ) begin
                    weighted_val = 31'b0;
                end else begin
                    weighted_val =
                            $signed(
                                input_image[
                                    ((stride*output_y + ky) * input_width
                                    + (stride*output_x + kx)) * 32
                                    +: 32
                                ]
                            )
                            *
                            $signed(
                                filter[
                                    (ky * kernel_size + kx) * weight_width
                                    +: weight_width
                                ]);
                end
                kernel_sum = kernel_sum + weighted_val;
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
