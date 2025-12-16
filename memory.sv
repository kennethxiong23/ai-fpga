module memory #(
    parameter string INIT_FILE = ""
)(
    output logic signed [784*32-1:0] read_data
);

    // Make the stored bytes signed (-128..127 or -127..127 depending on your file)
    logic signed [7:0] mem [0:2047];

    initial begin
        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, mem);

            for (int i = 0; i < 784; i++) begin
                // Sign-extend 8 -> 32
                read_data[i*32 +: 32] = $signed(mem[i]);
            end
        end
    end

endmodule
