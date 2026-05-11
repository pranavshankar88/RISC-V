`include "pc.v"
`include "register.v"
`include "alu.v"
`include "control.v"
`include "alu_control.v"
`include "instruction_memory.v"
`include "datamemory.v"
`include "immediate_generator.v"

module sequential(input clk ,reset);

    wire [63:0] pc_out;
    wire [63:0] pc_in;
    wire [63:0] pc_4;
    wire [31:0] instruction;
    wire [6:0] opcode;
    wire [4:0] read_reg1;
    wire [4:0] read_reg2;
    wire [4:0] write_reg;
    wire [63:0] immediate_data;
    wire [63:0] pc_sum;
    wire [63:0] Alu_in1;
    wire [63:0] Alu_in2;
    wire [63:0] aluresult;
    wire [63:0] reg_write_data;
    wire [63:0] data_out;
    wire [63:0] read_data2;
    wire [1:0] aluop;
    wire [3:0] ALU_operation;

    
    pc pc_inst (.clk(clk),.reset(reset),.pc_in(pc_in),.pc_out(pc_out));

    pc_add4 pc_add4_inst (.pc_out(pc_out),.pc_4(pc_4));
    instruction_memory tempinst (.address(pc_out),.instruction(instruction),.opcode(opcode),.read_reg1(read_reg1),.read_reg2(read_reg2),.write_reg(write_reg));
    immediate_generator temp_imme_gen (.instruction(instruction),.immediate_data(immediate_data));

    pc_add temppcadd (.sum(pc_sum),.ssl_by_1(immediate_data),.pc_out(pc_out));

    and(and_zero,zero,Branch);
    add_mux2x1 tempmux2 (.sum(pc_sum),.pc_4(pc_4),.branch_zero(and_zero),.pc_in(pc_in));
    register_file tempreg (.clk(clk),.reset(reset),.reg_write(reg_write),.reg_write_data(reg_write_data),.reg_write_addr(write_reg),.read_reg1(read_reg1),.read_reg2(read_reg2),.read_data1(Alu_in1),.read_data2(read_data2));
    reg_mux2x1 tempmux1 (.immediate_generator(immediate_data),.read_data2(read_data2),.ALUSrc(ALUSrc),.Alu_in2(Alu_in2));
    wrapper tempalu (.control(aluresult),.zero(zero),.operation(ALU_operation),.a(Alu_in1),.b(Alu_in2));
    ALU_Control temp_alu_control (.ALUop(aluop),.instruction(instruction),.ALU_operation(ALU_operation));
    data_memory temp_data_m (.clk(clk),.mem_read(MemRead),.mem_write(MemWrite),.address(aluresult),.write_data(read_data2),.data_out(data_out));
    dm_mux2x1 tempmux3 (.read_data(data_out),.alu_result(aluresult),.Mem_to_reg(MemtoReg),.write_data(reg_write_data));
    control tempcontrol (.opcode(opcode),.ALUSrc(ALUSrc),.MemtoReg(MemtoReg),.RegWrite(reg_write),.MemRead(MemRead),.MemWrite(MemWrite),.Branch(Branch),.ALUop(aluop));


endmodule