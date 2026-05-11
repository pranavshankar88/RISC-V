module control (
    input [6:0] opcode,   // 7-bit opcode input
    output reg ALUSrc,    // ALU Source selection
    output reg MemtoReg,  // Memory to Register control
    output reg RegWrite,  // Register Write enable
    output reg MemRead,   // Memory Read enable
    output reg MemWrite,  // Memory Write enable
    output reg Branch,    // Branch control signal
    output reg [1:0] ALUop // ALU operation control (ALUop1 and ALUop0 combined)
);

    always @(*) begin
        case (opcode)
            7'b0110011: begin // R-format
                ALUSrc   = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUop    = 2'b10;
            end
            7'b0000011: begin // Load (ld)
                ALUSrc   = 1;
                MemtoReg = 1;
                RegWrite = 1;
                MemRead  = 1;
                MemWrite = 0;
                Branch   = 0;
                ALUop    = 2'b00;
            end
            7'b0100011: begin // Store (sd)
                ALUSrc   = 1;
                MemtoReg = 1'bx; // Don't care
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 1;
                Branch   = 0;
                ALUop    = 2'b00;
            end
            7'b1100011: begin // Branch (beq)
                ALUSrc   = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 1;
                ALUop    = 2'b01;
            end
            default: begin // Default case to handle unknown opcodes
                ALUSrc   = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUop    = 2'b00;
            end
        endcase
    end

endmodule
