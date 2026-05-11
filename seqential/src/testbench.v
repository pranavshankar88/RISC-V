`include "main.v"
module testbench;
    reg clk,reset;
    
    sequential UUT(.clk(clk),.reset(reset));
    initial begin
        reset=1;
        clk=0;
        forever #5 clk=~clk;
    end

    initial begin
        $dumpfile("sequential.vcd");
        $dumpvars(0,testbench);
        $monitor("time:%0t clk=%d reset=%d",$time,clk,reset);
        #6 reset =0;
        #94 $finish;
    end

endmodule