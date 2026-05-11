module instruction_memory (
    input [63:0] address,
    output [31:0] instruction,
    output [6:0] opcode,
    output [4:0] read_reg1,
    output [4:0] read_reg2,
    output [4:0] write_reg
);
    reg [7:0] mem [0:1023];
    initial begin
        $readmemb("instructions1.txt", mem);
    end
    wire [9:0] mem_addr;
    assign mem_addr = address[9:0];
    
    wire [7:0] byte0, byte1, byte2, byte3;
    
    assign byte0 = mem[mem_addr];
    assign byte1 = mem[mem_addr + 1];
    assign byte2 = mem[mem_addr + 2];
    assign byte3 = mem[mem_addr + 3];
    
    assign instruction = {byte0, byte1, byte2, byte3};
    
    assign opcode = instruction[6:0];    // Opcode field
    assign read_reg1 = instruction[19:15];  // rs1 address
    assign read_reg2 = instruction[24:20];  // rs2 address
    assign write_reg = instruction[11:7];   // rd address
    
endmodule
