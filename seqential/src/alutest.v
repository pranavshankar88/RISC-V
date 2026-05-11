module alu_testbench;
    reg [2:0]  funct3;
    reg [6:0]  funct7;
    reg signed [63:0] A, B;
    wire signed [63:0] control;

    wrapper UUT (
        .control(control),
        .funct3(funct3),
        .funct7(funct7),
        .a(A),
        .b(B)
    );

    initial begin
        
        // ADD: funct3=000, funct7=0000000
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        A = 10; B = 5;
        #10 $display("ADD: %0d + %0d = %0d", A, B, control);
        
        A = 0; B = 0;
        #10 $display("ADD: 0 + 0 = %0d", control);
        
        A = 64'h7FFFFFFFFFFFFFFF; B = 1;
        #10 $display("ADD Overflow: %h + 1 = %h", A, control);
        
        A = 64'h7FFFFFFFFFFFFFFF; B = 64'h7FFFFFFFFFFFFFFF;
        #10 $display("ADD Overflow: %h + %h = %h", A, B, control);

        A = -1; B = 1;
        #10 $display("ADD: -1 + 1 = %0d", control);
        A = 64'h8000000000000000; B = -1;
        #10 $display("ADD INT_MIN + -1 = %h", control);

        // SUB: funct3=000, funct7=0100000
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        A = 10; B = 5;
        #10 $display("SUB: %0d - %0d = %0d", A, B, control);
        
        A = 5; B = 5;
        #10 $display("SUB: 5 - 5 = %0d", control);
        
        A = -5; B = 5;
        #10 $display("SUB: -5 - 5 = %0d", control);
        
        A = 64'h8000000000000000; B = 1;
        #10 $display("SUB INT_MIN - 1 = %h", control);

        // AND: funct3=111, funct7=0000000
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        A = 64'hAAAAAAAAAAAAAAAA; B = 64'h5555555555555555;
        #10 $display("AND: %h & %h = %h", A, B, control);
        
        A = 64'h123456789ABCDEF0; B = 0;
        #10 $display("AND with Zero: %h & 0 = %h", A, control);
        B = 64'hFFFFFFFFFFFFFFFF;
        #10 $display("AND with Ones: %h & FFFFFFFF = %h", A, control);

        // OR: funct3=110, funct7=0000000
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        A = 64'hAAAAAAAAAAAAAAAA; B = 64'h5555555555555555;
        #10 $display("OR: %h | %h = %h", A, B, control);
        
        B = 0;
        #10 $display("OR with Zero: %h | 0 = %h", A, control);
        B = 64'hFFFFFFFFFFFFFFFF;
        #10 $display("OR with Ones: %h | FFFFFFFF = %h", A, control);

        // XOR: funct3=100, funct7=0000000
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        A = 64'hAAAAAAAAAAAAAAAA; B = 64'h5555555555555555;
        #10 $display("XOR: %h ^ %h = %h", A, B, control);
        
        B = A;
        #10 $display("XOR Self: %h ^ %h = %h", A, B, control);
        
        B = 64'hFFFFFFFFFFFFFFFF;
        #10 $display("XOR Invert: %h ^ FFFFFFFF = %h", A, control);

        // SLL: funct3=001, funct7=0000000
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        A = 1; B = 5;
        #10 $display("SLL: 1 << 5 = %h", control);
        
        B = 0;
        #10 $display("SLL by 0: %h << 0 = %h", A, control);
        B = 63;  // actual shift using lower 5 bits
        #10 $display("SLL: 1 << 63 = %h", control);
        
        A = 64'h8000000000000000; B = 1;
        #10 $display("SLL INT_MIN << 1 = %h", control);

        // SRL: funct3=101, funct7=0000000
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        A = 64'h8000000000000000; B = 1;
        #10 $display("SRL: %h >> 1 = %h", A, control);
        
        B = 0;
        #10 $display("SRL by 0: %h >> 0 = %h", A, control);
        B = 63;  // using lower 5 bits for shift
        #10 $display("SRL: %h >> 63 = %h", A, control);
        
        A = 64'hFFFFFFFFFFFFFFFF; B = 31;
        #10 $display("SRL AllOnes >>31 = %h", control);

        // Additional ADD tests with funct3=000, funct7=0000000
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        A = 64'hFFFFFFFFFFFFFFFF; B = 1;
        #10 $display("ADD Carry Chain: %h + 1 = %h", A, control);
        

        A = 64'h7FFFFFFFFFFFFFFF; B = -1;
        #10 $display("ADD MaxPos + -1 = %h", control);

        // Additional SUB tests with funct3=000, funct7=0100000
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        A = -5; B = -3;
        #10 $display("SUB: -5 - (-3) = %0d", control);
        
        A = 64'h7FFFFFFFFFFFFFFF; B = 64'h7FFFFFFFFFFFFFFF;
        #10 $display("SUB MaxPos Twins: %h - %h = %h", A, B, control);
        
        A = 0; B = 64'h8000000000000000;
        #10 $display("SUB 0 - INT_MIN = %h", control);

        // AND additional tests (funct3=111, funct7=0000000)
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        A = 64'h123456789ABCDEF0; B = 64'h000000000000FFFF;
        #10 $display("AND LowWord: %h & %h = %h", A, B, control);
        
        B = 64'h8000000000000000;
        #10 $display("AND HighBit: %h & %h = %h", A, B, control);

        // OR additional tests (funct3=110, funct7=0000000)
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        A = 64'h0000000012340000; B = 64'h0000000000005678;
        #10 $display("OR CombineNibbles: %h | %h = %h", A, B, control);

        // XOR additional tests (funct3=100, funct7=0000000)
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        A = 64'hA5A5A5A5A5A5A5A5; B = 64'h0F0F0F0F0F0F0F0F;
        #10 $display("XOR FlipPattern: %h ^ %h = %h", A, B, control);
        
        B = 64'hFFFF0000FFFF0000;
        #10 $display("XOR HalfInvert: %h ^ %h = %h", A, B, control);

        // Multi-word shift SLL: funct3=001, funct7=0000000
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        A = 64'h00000000FFFFFFFF; B = 16;
        #10 $display("SLL WordShift: %h << 16 = %h", A, control);
        
        // Negative shift amount (using 2's complement)
        B = -1; // interpreted as 31 in 5-bit unsigned
        #10 $display("SLL NegativeShift: %h << -1(31) = %h", A, control);

        // BYTE SHIFT SRL: funct3=101, funct7=0000000
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        A = 64'h123456789ABCDEF0; B = 8;
        #10 $display("SRL ByteShift: %h >> 8 = %h", A, control);
        
        A = 1; B = 1;
        #10 $display("SRL SingleBit: %h >> 1 = %h", A, control);

        // ADD with opposites: funct3=000, funct7=0000000
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        A = 64'h7FFFFFFFFFFFFFFF; B = 64'h8000000000000000;
        #10 $display("ADD MaxOpposites: %h + %h = %h", A, B, control);

        // SUB twins: funct3=000, funct7=0100000
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        A = 64'h8000000000000000; B = 64'h8000000000000000;
        #10 $display("SUB INT_MIN Twins: %h - %h = %h", A, B, control);

        // SLT Test: funct3=010 (signed less than)
        funct3 = 3'b010;
        funct7 = 7'b0000000; // funct7 is not used for SLT
        A = 10; B = 20;
        #10 $display("SLT: %0d < %0d ? = %h", A, B, control);
        
        A = -5; B = 5;
        #10 $display("SLT: %0d < %0d ? = %h", A, B, control);
        
        A = 20; B = 10;
        #10 $display("SLT: %0d < %0d ? = %h", A, B, control);

        // SLTU Test: funct3=011 (unsigned less than)
        funct3 = 3'b011;
        funct7 = 7'b0000000; // funct7 is not used for SLTU
        A = 10; B = 20;
        #10 $display("SLTU: %0d < %0d ? = %h", A, B, control);
        
        A = 64'hFFFFFFFFFFFFFFFF; B = 0;
        #10 $display("SLTU: %h < %h ? = %h", A, B, control);
        
        A = 20; B = 10;
        #10 $display("SLTU: %0d < %0d ? = %h", A, B, control);

        $finish;
    end
endmodule