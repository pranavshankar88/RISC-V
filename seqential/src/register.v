//register.v
module register_file (
    input clk,reset,reg_write,input [63:0] reg_write_data,input [4:0] reg_write_addr,read_reg1,read_reg2, output reg [63:0] read_data1,read_data2);

    reg [63:0] reg_file [0:31];
    integer i;
    always @(posedge reset ) begin 
        for(i=0;i<32;i=i+1)
            reg_file[i] <= 64'b0;
    end
    // Synchronous reset and write.
    always @(posedge clk) begin
            if (reg_write) begin
                if(reg_write_addr != 0)
                    reg_file[reg_write_addr] <= reg_write_data;
                    else
                    reg_file[0] <= 64'b0;
            end
    end 
    //Asynchronous read
    always @(*) begin
        read_data1 = reg_file[read_reg1];
        read_data2 = reg_file[read_reg2];
    end
endmodule

//mux after register file
module reg_mux2x1 (input [63:0] immediate_generator, read_data2, input ALUSrc, output [63:0] Alu_in2);
    assign Alu_in2 = ALUSrc ? immediate_generator : read_data2;
endmodule