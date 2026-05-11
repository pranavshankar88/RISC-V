module ALU_Control (
    input [1:0] ALUop,
    input [31:0] instruction ,
    output reg [3:0] ALU_operation
);
    wire [2:0] funct3 = instruction[14:12];
    assign funct7 = instruction[30];
    always @(*) begin
        case(ALUop)
            2'b00: ALU_operation = 4'b0000; // Load/store (add)
            2'b01: ALU_operation = 4'b1000; // Branch (subtract)
            2'b10: begin
                case(funct3)
                    3'b000: ALU_operation = (funct7) ? 4'b1000 : 4'b0000; // Subtract if funct7=1, else Add
                    3'b001: ALU_operation = 4'b0001; // SLL
                    3'b010: ALU_operation = 4'b0010; // SLT
                    3'b011: ALU_operation = 4'b0011; // SLTU
                    3'b100: ALU_operation = 4'b0100; // XOR
                    3'b101: ALU_operation = (funct7) ? 4'b1101 : 4'b0101; // SRA if funct7=1, else SRL
                    3'b110: ALU_operation = 4'b0110; // OR
                    3'b111: ALU_operation = 4'b0111; // AND
                endcase
            end
            
        endcase
    end

endmodule
