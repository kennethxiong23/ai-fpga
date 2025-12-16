module max_pool2d #(
    parameter int in_width  = 28,
    parameter int out_width = 14
)(
    input  logic        reset,
    input  logic clk,
    input  logic signed [in_width*in_width*32-1:0]   in_map,
    output logic signed [out_width*out_width*32-1:0] out_map,
    output logic done
);
    int unsigned out_y = 0;
    int unsigned out_x = 0;

    logic signed [31:0] max_val;
    logic signed [31:0] curr_val;

    always_comb begin

        max_val = in_map[((2*out_y)*in_width + (2*out_x))*32 +: 32];

        for (int ky = 0; ky < 2; ky++) begin
            for (int kx = 0; kx < 2; kx++) begin
               if ((2*out_y + ky) < in_width && (2*out_x + kx) < in_width) begin
                curr_val = in_map[((2*out_y + ky)*in_width + (2*out_x + kx))*32 +: 32];
                end else begin
                curr_val = 32'd0; 
            end 
                if ($signed(curr_val) > $signed(max_val)) max_val = curr_val;
            end
        end
    end


    always_ff @(posedge clk) begin
        if (reset) begin
            out_x <= 0;
            out_y <= 0;
            done <= 0;
        end else if (done == 0 && out_y == out_width - 1 && out_x == out_width - 1) begin
            done <= 1;
        end else if (out_x == out_width - 1) begin
            out_x <= 0;
            if (out_y == out_width - 1) out_y <= 0;
            else                        out_y <= out_y + 1;
        end else begin
            out_x <= out_x + 1;
        end
        out_map[(out_y*out_width + out_x)*32 +: 32] <= max_val;

    end

endmodule
