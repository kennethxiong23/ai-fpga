module relu #(
    parameter int map_width
)
(
    input logic clk,
    input logic signed [map_width*map_width*32-1:0] input_map,
    output logic signed [map_width*map_width*32-1:0] output_map,
    output logic done
);

int x = 0;
int y = 0;
int idx;
initial begin
done = 0;
end
always_ff @(posedge clk) begin

    if (!done) begin
        idx <= (x*map_width + y) * 32; 
        output_map[idx +:32] <= 
            (input_map[idx +:32] > 0) ? input_map[idx +:32] : 32'd0;
        
        if (x == map_width-1 && y == map_width-1) begin
            x <= 0;
            y <= 0;
        end else if (y == map_width-1) begin
            y <= 0;
            x <= x+1;
        end else begin
            y <= y+1;
        end
    end

end


endmodule

