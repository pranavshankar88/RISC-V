module data_memory (input clk,mem_read,mem_write,input  [63:0] address,write_data,output reg [63:0] data_out);
    reg [7:0] mem [0:1023];
    integer i;
    wire [6:0] word_index = address[9:3];
    wire [9:0] base_index = {word_index, 3'b000};
    initial begin
        $readmemb("data_memory_preload1.txt", mem);
    end
    always @(*) begin
        if (mem_read)
            data_out = { mem[base_index],mem[base_index+1],mem[base_index+2],mem[base_index+3],mem[base_index+4],mem[base_index+5],mem[base_index+6],mem[base_index+7]};
        else
            data_out = 64'b0;
    end
    always @(posedge clk) begin
        if (mem_write) begin
            mem[base_index+7]     <= write_data[7:0];
            mem[base_index+6]   <= write_data[15:8];
            mem[base_index+5]   <= write_data[23:16];
            mem[base_index+4]   <= write_data[31:24];
            mem[base_index+3]   <= write_data[39:32];
            mem[base_index+2]   <= write_data[47:40];
            mem[base_index+1]   <= write_data[55:48];
            mem[base_index]   <= write_data[63:56];
        end
    end
endmodule

// mux.v
module dm_mux2x1 (input [63:0] read_data, alu_result, input Mem_to_reg, output [63:0] write_data);
  assign write_data = Mem_to_reg ? read_data : alu_result;
endmodule
