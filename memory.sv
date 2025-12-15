module memory #(
    parameter INIT_FILE = ""
)(
    output logic [6271:0] read_data
);

    logic [7:0] mem [0:2047];

    initial if (INIT_FILE) begin
        $readmemh(INIT_FILE, mem);  
        for (int i = 0; i < 784; i++) begin
            read_data[i*8 +: 8] = mem[i];
        end
    end


endmodule
