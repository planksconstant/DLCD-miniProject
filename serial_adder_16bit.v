module serial_adder_16bit (
    input clk,
    input rst,
    input start,           
    input [15:0] a_in,
    input [15:0] b_in,
    output reg [15:0] sum_out,
    output reg cout_final,
    output reg done        
);

    reg [4:0] count;       
    reg shifting;          
    
    wire a_bit, b_bit;
    wire sum_bit, carry_next;
    reg carry_reg;         

    wire [15:0] reg_a_val, reg_b_val;
    
    shift_register reg_a (
        .clk(clk),
        .rst(rst),
        .load(start),
        .shift_en(shifting),
        .serial_in(1'b0),
        .parallel_in(a_in),
        .serial_out(a_bit),
        .reg_out(reg_a_val)
    );

    shift_register reg_b (
        .clk(clk),
        .rst(rst),
        .load(start),
        .shift_en(shifting),
        .serial_in(1'b0),
        .parallel_in(b_in),
        .serial_out(b_bit),
        .reg_out(reg_b_val)
    );

    full_adder fa (
        .a(a_bit),
        .b(b_bit),
        .cin(carry_reg),
        .sum(sum_bit),
        .cout(carry_next)
    );

    reg [15:0] sum_shift;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count      <= 5'd0;
            shifting   <= 1'b0;
            done       <= 1'b0;
            carry_reg  <= 1'b0;
            sum_shift  <= 16'b0;
            sum_out    <= 16'b0;
            cout_final <= 1'b0;
        end else begin
            if (start) begin
                count      <= 5'd0;
                shifting   <= 1'b1;
                done       <= 1'b0;
                carry_reg  <= 1'b0; 
                sum_shift  <= 16'b0;
            end else if (shifting) begin
                sum_shift <= {sum_bit, sum_shift[15:1]};
                
                carry_reg <= carry_next;

                if (count == 5'd15) begin
                    shifting   <= 1'b0;
                    done       <= 1'b1;
                    sum_out    <= {sum_bit, sum_shift[15:1]};
                    cout_final <= carry_next;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
