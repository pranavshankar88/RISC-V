module pc (input  wire clk,reset,input  wire [63:0] pc_in,output reg  [63:0] pc_out);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 64'b0;
        else
            pc_out <= pc_in;
    end
endmodule

module full_adder (output sum,cout,input rs1,rs2,cin);
    wire xor1, and1, and2, and3, or1;
    xor (xor1, rs1, rs2);
    xor (sum, xor1, cin);
    and (and1, rs1, rs2);
    and (and2, rs2, cin);
    and (and3, cin, rs1);
    or (or1, and1, and2);
    or (cout, or1, and3);
endmodule

module ripple_adder (output [63:0] sum,input [63:0] rs1,rs2,input cin);
    wire [63:0] carry;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : adder_loop
            if (!i)
                full_adder FA (sum[i], carry[i], rs1[i], rs2[i], cin);
            else
                full_adder FA (sum[i], carry[i], rs1[i], rs2[i], carry[i-1]);
        end
    endgenerate
    assign cout = carry[63];
    assign overflow = carry[62] ^ carry[63];
endmodule

module pc_add4 (input [63:0] pc_out,output [63:0] pc_4);
    ripple_adder add_inst (
        .sum(pc_4),
        .rs1(pc_out),
        .rs2(64'd4),
        .cin(1'b0)
    );
endmodule

module pc_add (output [63:0] sum,input [63:0] ssl_by_1,pc_out);
    ripple_adder add_inst (
        .sum(sum),
        .rs1(ssl_by_1),
        .rs2(pc_out),
        .cin(1'b0)
    );
endmodule

module add_mux2x1 (input [63:0] sum,pc_4,input branch_zero,output [63:0] pc_in);
    assign pc_in = branch_zero ? sum : pc_4;
endmodule
