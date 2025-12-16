module memory #(
    parameter string INIT_FILE = "",
    parameter int image_width = 28
)(
    output logic signed [image_width*image_width*32-1:0] read_data
);

    // Make the stored bytes signed (-128..127 or -127..127 depending on your file)
    logic signed [7:0] mem [0:2047];

    initial begin
        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, mem);

            for (int i = 0; i < image_width*image_width; i++) begin
                // Sign-extend 8 -> 32
                read_data[i*32 +: 32] = $signed(mem[i]);
            end
        end
    end

endmodule
