module wrapper(
    output reg [63:0] control,
    output zero,
    input [3:0] operation,
    input [63:0] a,
    input [63:0] b
);
    wire [63:0] sum, difference, a_xor_b, a_or_b, a_and_b;
    wire [63:0] sllout, srlout, sraout;
    wire [63:0] carry;
    wire sltout, sltuout;
    wire [5:0] shift;
    assign shift = b[5:0];

    add tempadd(.a(a),.b(b),.out(sum));
    subtract tempsub(a, b,difference);
    xorgate tempxor(a, b, a_xor_b);
    orgate tempor( a, b,a_or_b);
    andgate tempand( a, b,a_and_b);
    sll tempsll(a, shift,sllout);
    srl tempsrl(a, shift,srlout);
    sra tempsra(a, shift,sraout);
    slt tempslt(a, b,sltout);
    sltu tempsltu(a, b,sltuout);
    zero_detector tempzero(control, zero);
    always @(*) begin
        
        case(operation)
            4'b0000: control = sum; // add
            4'b1000: control = difference; // sub
            4'b0100: control = a_xor_b; // xor
            4'b0110: control = a_or_b;  // or
            4'b0111: control = a_and_b; // and
            4'b0001: control = sllout;  // sll
            4'b0101: control = srlout; // srl
            4'b1101: control = sraout; // sra
            4'b0010: control = {63'b0, sltout};  // slt
            4'b0011: control = {63'b0, sltuout}; // sltu
            default: control = 64'b0;
        endcase
    end
endmodule

module zero_detector (
    input [63:0] control, 
    output zero           
);
    wire control_or; 
    or (control_or, 
        control[0], control[1], control[2], control[3], control[4], control[5], control[6], control[7],
        control[8], control[9], control[10], control[11], control[12], control[13], control[14], control[15],
        control[16], control[17], control[18], control[19], control[20], control[21], control[22], control[23],
        control[24], control[25], control[26], control[27], control[28], control[29], control[30], control[31],
        control[32], control[33], control[34], control[35], control[36], control[37], control[38], control[39],
        control[40], control[41], control[42], control[43], control[44], control[45], control[46], control[47],
        control[48], control[49], control[50], control[51], control[52], control[53], control[54], control[55],
        control[56], control[57], control[58], control[59], control[60], control[61], control[62], control[63]
    );
    not (zero, control_or);

endmodule


module sll(
    input [63:0] a,
    input [5:0] select,
    output [63:0] out
);

wire [63:0] faltu1, faltu2, faltu3, faltu4, faltu5;

mux m0 (.a(a[0]), .b(1'b0), .sel(select[0]), .out(faltu1[0]));
genvar i;
generate
    for(i = 1; i < 64; i = i + 1) begin
        mux m1 (.a(a[i]), .b(a[i-1]), .sel(select[0]), .out(faltu1[i]));
    end
endgenerate

generate
    for(i = 0; i < 2; i = i + 1) begin
        mux m2 (.a(faltu1[i]), .b(1'b0), .sel(select[1]), .out(faltu2[i]));
    end
    for(i = 2; i < 64; i = i + 1) begin
        mux m3 (.a(faltu1[i]), .b(faltu1[i-2]), .sel(select[1]), .out(faltu2[i]));
    end
endgenerate

generate
    for(i = 0; i < 4; i = i + 1) begin
        mux m4 (.a(faltu2[i]), .b(1'b0), .sel(select[2]), .out(faltu3[i]));
    end
    for(i = 4; i < 64; i = i + 1) begin
        mux m5 (.a(faltu2[i]), .b(faltu2[i-4]), .sel(select[2]), .out(faltu3[i]));
    end
endgenerate

generate
    for(i = 0; i < 8; i = i + 1) begin
        mux m6 (.a(faltu3[i]), .b(1'b0), .sel(select[3]), .out(faltu4[i]));
    end
    for(i = 8; i < 64; i = i + 1) begin
        mux m7 (.a(faltu3[i]), .b(faltu3[i-8]), .sel(select[3]), .out(faltu4[i]));
    end
endgenerate

generate
    for(i = 0; i < 16; i = i + 1) begin
        mux m8 (.a(faltu4[i]), .b(1'b0), .sel(select[4]), .out(faltu5[i]));
    end
    for(i = 16; i < 64; i = i + 1) begin
        mux m9 (.a(faltu4[i]), .b(faltu4[i-16]), .sel(select[4]), .out(faltu5[i]));
    end
endgenerate

generate
    for(i = 0; i < 32; i = i + 1) begin
        mux m10 (.a(faltu5[i]), .b(1'b0), .sel(select[5]), .out(out[i]));
    end
    for(i = 32; i < 64; i = i + 1) begin
        mux m11 (.a(faltu5[i]), .b(faltu5[i-32]), .sel(select[5]), .out(out[i]));
    end
endgenerate

endmodule

module srl(
    input [63:0] a,
    input [5:0] select,
    output [63:0] out
);

wire [63:0] faltu1, faltu2, faltu3, faltu4, faltu5;

mux m0 (.a(a[63]), .b(1'b0), .sel(select[0]), .out(faltu1[63]));
genvar i;
generate
    for(i = 0; i < (64-1); i = i + 1) begin
        mux m1 (.a(a[i]), .b(a[i+1]), .sel(select[0]), .out(faltu1[i]));
    end
endgenerate

generate
    for(i = 62; i < 64; i = i + 1) begin
        mux m2 (.a(faltu1[i]), .b(1'b0), .sel(select[1]), .out(faltu2[i]));
    end
    for(i = 0; i < 62; i = i + 1) begin
        mux m3 (.a(faltu1[i]), .b(faltu1[i+2]), .sel(select[1]), .out(faltu2[i]));
    end
endgenerate

generate
    for(i = 60; i < 64; i = i + 1) begin
        mux m4 (.a(faltu2[i]), .b(1'b0), .sel(select[2]), .out(faltu3[i]));
    end
    for(i = 0; i < 60; i = i + 1) begin
        mux m5 (.a(faltu2[i]), .b(faltu2[i+4]), .sel(select[2]), .out(faltu3[i]));
    end
endgenerate

generate
    for(i = 56; i < 64; i = i + 1) begin
        mux m6 (.a(faltu3[i]), .b(1'b0), .sel(select[3]), .out(faltu4[i]));
    end
    for(i = 0; i < 56; i = i + 1) begin
        mux m7 (.a(faltu3[i]), .b(faltu3[i+8]), .sel(select[3]), .out(faltu4[i]));
    end
endgenerate

generate
    for(i = 48; i < 64; i = i + 1) begin
        mux m8 (.a(faltu4[i]), .b(1'b0), .sel(select[4]), .out(faltu5[i]));
    end
    for(i = 0; i < 48; i = i + 1) begin
        mux m9 (.a(faltu4[i]), .b(faltu4[i+16]), .sel(select[4]), .out(faltu5[i]));
    end
endgenerate

generate
    for(i = 32; i < 64; i = i + 1) begin
        mux m10 (.a(faltu5[i]), .b(1'b0), .sel(select[5]), .out(out[i]));
    end
    for(i = 0; i < 32; i = i + 1) begin
        mux m11 (.a(faltu5[i]), .b(faltu5[i+32]), .sel(select[5]), .out(out[i]));
    end
endgenerate
endmodule

module sra(
    input [63:0] a,
    input [5:0] select,
    output [63:0] out
);

wire [63:0] faltu1, faltu2, faltu3, faltu4, faltu5;

mux m0 (.a(a[63]), .b(a[63]), .sel(select[0]), .out(faltu1[63]));
genvar i;
generate
    for(i = 0; i < (64-1); i = i + 1) begin
        mux m1 (.a(a[i]), .b(a[i+1]), .sel(select[0]), .out(faltu1[i]));
    end
endgenerate

generate
    for(i = 62; i < 64; i = i + 1) begin
        mux m2 (.a(faltu1[i]), .b(a[63]), .sel(select[1]), .out(faltu2[i]));
    end
    for(i = 0; i < 62; i = i + 1) begin
        mux m3 (.a(faltu1[i]), .b(faltu1[i+2]), .sel(select[1]), .out(faltu2[i]));
    end
endgenerate

generate
    for(i = 60; i < 64; i = i + 1) begin
        mux m4 (.a(faltu2[i]), .b(a[63]), .sel(select[2]), .out(faltu3[i]));
    end
    for(i = 0; i < 60; i = i + 1) begin
        mux m5 (.a(faltu2[i]), .b(faltu2[i+4]), .sel(select[2]), .out(faltu3[i]));
    end
endgenerate

generate
    for(i = 56; i < 64; i = i + 1) begin
        mux m6 (.a(faltu3[i]), .b(a[63]), .sel(select[3]), .out(faltu4[i]));
    end
    for(i = 0; i < 56; i = i + 1) begin
        mux m7 (.a(faltu3[i]), .b(faltu3[i+8]), .sel(select[3]), .out(faltu4[i]));
    end
endgenerate

generate
    for(i = 48; i < 64; i = i + 1) begin
        mux m8 (.a(faltu4[i]), .b(a[63]), .sel(select[4]), .out(faltu5[i]));
    end
    for(i = 0; i < 48; i = i + 1) begin
        mux m9 (.a(faltu4[i]), .b(faltu4[i+16]), .sel(select[4]), .out(faltu5[i]));
    end
endgenerate

generate
    for(i = 32; i < 64; i = i + 1) begin
        mux m10 (.a(faltu5[i]), .b(a[63]), .sel(select[5]), .out(out[i]));
    end
    for(i = 0; i < 32; i = i + 1) begin
        mux m11 (.a(faltu5[i]), .b(faltu5[i+32]), .sel(select[5]), .out(out[i]));
    end
endgenerate
endmodule

module andgate(
    input [63:0] a,
    input [63:0] b,
    output [63:0] out
);
genvar i;
generate
    for(i = 0; i < 64; i = i + 1) begin
        and(out[i],a[i],b[i]);
    end
endgenerate
endmodule

module orgate(
    input [63:0] a,
    input [63:0] b,
    output [63:0] out
);
genvar i;
generate
    for(i = 0; i < 64; i = i + 1) begin
        or(out[i],a[i],b[i]);
    end
endgenerate
endmodule

module xorgate(
    input [63:0] a,
    input [63:0] b,
    output [63:0] out
);
genvar i;
generate
    for(i = 0; i < 64; i = i + 1) begin
        xor(out[i],a[i],b[i]);
    end
endgenerate
endmodule

module add(
    input [63:0] a,
    input [63:0] b,
    output [63:0] out
);
wire [63:0] g,p,c,faltu1,faltu2;

andgate a0(.a(a), .b(b), .out(g));
orgate o0(.a(a), .b(b), .out(p));
and(c[0],1'b0,1'b0);
genvar i;
generate
    for(i = 1; i < 64; i = i + 1) begin
        and(faltu1[i],p[i-1],c[i-1]);
        or(c[i],g[i-1],faltu1[i]);
    end
endgenerate

xorgate x0(.a(a), .b(b), .out(faltu2));
xorgate x1(.a(faltu2), .b(c), .out(out));

endmodule

module subtract(
    input [63:0] a,
    input [63:0] b,
    output [63:0] out
);

wire [63:0] g,p,c,faltu1,faltu2,ulta;
genvar i;
generate
    for(i=0;i<64;i=i+1) begin
        not(ulta[i],b[i]);
    end
endgenerate

andgate a0(.a(a), .b(ulta), .out(g));
orgate o0(.a(a), .b(ulta), .out(p));
and(c[0],1'b1,1'b1);

generate
    for(i = 1; i < 64; i = i + 1) begin
        and(faltu1[i],p[i-1],c[i-1]);
        or(c[i],g[i-1],faltu1[i]);
    end
endgenerate

xorgate x0(.a(a), .b(ulta), .out(faltu2));
xorgate x1(.a(faltu2), .b(c), .out(out));


endmodule

module slt(
    input [63:0] a,
    input [63:0] b,
    output sltout
);

wire [63:0] g,p,c,faltu1,faltu2,ulta,out;
genvar i;
generate
    for(i=0;i<64;i=i+1) begin
        not(ulta[i],b[i]);
    end
endgenerate

andgate a0(.a(a), .b(ulta), .out(g));
orgate o0(.a(a), .b(ulta), .out(p));
and(c[0],1'b1,1'b1);

generate
    for(i = 1; i < 64; i = i + 1) begin
        and(faltu1[i],p[i-1],c[i-1]);
        or(c[i],g[i-1],faltu1[i]);
    end
endgenerate

xorgate x0(.a(a), .b(ulta), .out(faltu2));
xorgate x1(.a(faltu2), .b(c), .out(out));

and(sltout,out[63],1'b1);
endmodule

module sltu(
    input [63:0] a,
    input [63:0] b,
    output less
);
    wire [63:0] x, g, p;  
    wire [63:0] eq;
    
    genvar i;
    generate
        for(i = 0; i < 64; i = i + 1) begin
            xor (x[i], a[i], b[i]);  
            and (g[i], ~a[i], b[i]); 
            nor (p[i], a[i], b[i]);  
        end
    endgenerate

    assign eq[63] = 1'b1;  
    generate
        for(i = 62; i >= 0; i = i - 1) begin
            and(eq[i], eq[i+1], ~x[i+1]);
        end
    endgenerate
    wire [63:0] eq_and_g;
    generate
        for (i = 0; i < 64; i = i + 1) begin
            and(eq_and_g[i], eq[i], g[i]); 
        end
    endgenerate
    or final_or(less, eq_and_g[0], eq_and_g[1], eq_and_g[2], eq_and_g[3], eq_and_g[4], eq_and_g[5], eq_and_g[6], eq_and_g[7],eq_and_g[8], eq_and_g[9], eq_and_g[10], eq_and_g[11], eq_and_g[12], eq_and_g[13], eq_and_g[14], eq_and_g[15],eq_and_g[16], eq_and_g[17], eq_and_g[18], eq_and_g[19], eq_and_g[20], eq_and_g[21], eq_and_g[22], eq_and_g[23],eq_and_g[24], eq_and_g[25], eq_and_g[26], eq_and_g[27], eq_and_g[28], eq_and_g[29], eq_and_g[30], eq_and_g[31],eq_and_g[32], eq_and_g[33], eq_and_g[34], eq_and_g[35], eq_and_g[36], eq_and_g[37], eq_and_g[38], eq_and_g[39],eq_and_g[40], eq_and_g[41], eq_and_g[42], eq_and_g[43], eq_and_g[44], eq_and_g[45], eq_and_g[46], eq_and_g[47],eq_and_g[48], eq_and_g[49], eq_and_g[50], eq_and_g[51], eq_and_g[52], eq_and_g[53], eq_and_g[54], eq_and_g[55],eq_and_g[56], eq_and_g[57], eq_and_g[58], eq_and_g[59], eq_and_g[60], eq_and_g[61], eq_and_g[62], eq_and_g[63]);
endmodule

module mux(
    input a,
    input b,
    input sel,
    output out
);
    wire faltu1,faltu2;
    and(faltu1, ~sel, a);
    and(faltu2, sel, b);
    or(out,faltu1, faltu2);
endmodule
