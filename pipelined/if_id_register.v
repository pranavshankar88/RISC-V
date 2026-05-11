module if_id_register (
    input clk,
    input reset,
    input stall,
    input flush,
    
    input [63:0] pc_in,
    input [31:0] instruction_in,
    input [63:0] pc_4_in,
    
    output reg [63:0] pc_out,
    output reg [31:0] instruction_out,
    output reg [63:0] pc_4_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 64'b0;
            instruction_out <= 32'b0;
            pc_4_out <= 64'b0;
        end
        else if (flush) begin
            pc_out <= 64'b0;
            instruction_out <= 32'b0;
            pc_4_out <= 64'b0;
        end
        else if (!stall) begin
            pc_out <= pc_in;
            instruction_out <= instruction_in;
            pc_4_out <= pc_4_in;
        end
    end

endmodule
