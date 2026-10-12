module shift_register (
    input clk,
    input rst,
    input load,          
    input shift_en,      
    input serial_in,     
    input [15:0] parallel_in,
    output serial_out,   
    output [15:0] reg_out
);

    reg [15:0] storage;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            storage <= 16'b0;
        end else if (load) begin
            storage <= parallel_in;
        end else if (shift_en) begin
            storage <= {serial_in, storage[15:1]};
        end
    end

    assign serial_out = storage[0];
    assign reg_out    = storage;

endmodule
