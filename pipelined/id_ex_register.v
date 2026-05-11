module id_ex_register (
    input clk,
    input reset,
    input flush,
    
    input ALUSrc_in,
    input MemtoReg_in,
    input RegWrite_in,
    input MemRead_in,
    input MemWrite_in,
    input Branch_in,
    input [1:0] ALUop_in,
    
    input [63:0] pc_in,
    input [63:0] pc_4_in,
    input [63:0] reg_data1_in,
    input [63:0] reg_data2_in,
    input [63:0] imm_data_in,
    input [31:0] instruction_in,
    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input [4:0] rd_in,
    

    output reg ALUSrc_out,
    output reg MemtoReg_out,
    output reg RegWrite_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg Branch_out,
    output reg [1:0] ALUop_out,
    

    output reg [63:0] pc_out,
    output reg [63:0] pc_4_out,
    output reg [63:0] reg_data1_out,
    output reg [63:0] reg_data2_out,
    output reg [63:0] imm_data_out,
    output reg [31:0] instruction_out,
    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out
);

    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            // Control signals
            ALUSrc_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            RegWrite_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemWrite_out <= 1'b0;
            Branch_out <= 1'b0;
            ALUop_out <= 2'b00;
            
            // Data signals
            pc_out <= 64'b0;
            pc_4_out <= 64'b0;
            reg_data1_out <= 64'b0;
            reg_data2_out <= 64'b0;
            imm_data_out <= 64'b0;
            instruction_out <= 32'b0;
            rs1_out <= 5'b0;
            rs2_out <= 5'b0;
            rd_out <= 5'b0;
        end
        else begin
            // Control signals
            ALUSrc_out <= ALUSrc_in;
            MemtoReg_out <= MemtoReg_in;
            RegWrite_out <= RegWrite_in;
            MemRead_out <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            Branch_out <= Branch_in;
            ALUop_out <= ALUop_in;
            
            // Data signals
            pc_out <= pc_in;
            pc_4_out <= pc_4_in;
            reg_data1_out <= reg_data1_in;
            reg_data2_out <= reg_data2_in;
            imm_data_out <= imm_data_in;
            instruction_out <= instruction_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            rd_out <= rd_in;
        end
    end

endmodule
