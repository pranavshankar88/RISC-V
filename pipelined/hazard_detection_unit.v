module hazard_detection(
    input  wire id_ex_mem_rd,     // 1 if ID/EX instruction is a load
    input  wire [4:0]  id_ex_reg_rd,       // Destination register of the load
    input  wire [31:0] if_id_instruction,  // Current IF/ID instruction (contains Rs1/Rs2)
    output reg  pc_write,          // PC update enable (stall if 0)
    output reg  if_id_write,        // IF/ID register update enable (stall if 0)
    output reg  id_ex_flush         // Flush/insert bubble in ID/EX if 1
);

  // Extract Rs1 and Rs2 from the IF/ID instruction.
  // For a typical R-type or I-type RISC-V instruction:
  //   bits [19:15] = rs1
  //   bits [24:20] = rs2
  wire [4:0] if_id_rs1 = if_id_instruction[19:15];
  wire [4:0] if_id_rs2 = if_id_instruction[24:20];

  always @(*) begin
    // Default behavior: no stall, normal pipeline operation
    pc_write   = 1'b1;
    if_id_write = 1'b1;
    id_ex_flush = 1'b0;

    // Check for load-use hazard:
    // if (ID/EX is a load) AND (destination register == IF/ID's Rs1 or Rs2)
    if (id_ex_mem_rd &&
        ((id_ex_reg_rd == if_id_rs1) || (id_ex_reg_rd == if_id_rs2)) &&
        (id_ex_reg_rd != 5'd0)) 
    begin
      // Stall the pipeline
      pc_write   = 1'b0;  // Freeze PC (no new instruction fetch)
      if_id_write = 1'b0;  // Freeze IF/ID register
      id_ex_flush = 1'b1;  // Next cycle: turn the ID/EX instruction into a bubble
    end
  end

endmodule
