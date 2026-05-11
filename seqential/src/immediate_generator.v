module immediate_generator (
    input [31:0] instruction,
    output [63:0] immediate_data
);
    wire [6:0] opcode;
    assign opcode = instruction[6:0];
    
    wire [11:0] i_imm;
    wire [11:0] s_imm;
    wire [12:0] b_imm;
    
    assign i_imm = instruction[31:20];
    assign s_imm = {instruction[31:25], instruction[11:7]};
    assign b_imm = {instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
    
    wire [63:0] i_imm_ext;
    wire [63:0] s_imm_ext;
    wire [63:0] b_imm_ext;
    
    assign i_imm_ext = {{52{i_imm[11]}}, i_imm};
    assign s_imm_ext = {{52{s_imm[11]}}, s_imm};
    assign b_imm_ext = {{51{b_imm[12]}}, b_imm};
    
    wire [63:0] imm_out;
    
    assign imm_out = (opcode == 7'b0000011) ? i_imm_ext :   // ld
                    (opcode == 7'b0100011) ? s_imm_ext :   // sd
                    (opcode == 7'b1100011) ? b_imm_ext :   // beq
                    64'b0;                                 // all the orther opcodes
                    
    assign immediate_data = imm_out;
    
endmodule
