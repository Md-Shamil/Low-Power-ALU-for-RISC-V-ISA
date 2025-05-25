// Latch-based Full Adder module with Enable Control
module latch_based_full_adder (
    input A,
    input B,
    input X,
    input en1,      // Enable for the sum calculation
    input en2,      // Enable for carry out calculation
    output reg sum,
    output reg carry_out,
    output A_AND_B,
    output A_XOR_B,
    output A_AND_B_internal
);

    wire xor_out, and_out;

    // Calculate XOR and AND only if enabled
    assign A_XOR_B = en1 ? (A ^ B) : 0;
    assign A_AND_B_internal = en2 ? (A & B) : 0;

    // Latch-based sum and carry out calculations
    always @(*) begin
        if (en1)
            sum = A_XOR_B ^ X;
        if (en2)
            carry_out = (A_XOR_B & X) | A_AND_B_internal;
    end

    // Additional operation for A'AND B
    assign A_AND_B = ~A & B;
endmodule

// Latch-based ALU with Controlled Enable Signals
module latch_based_alu (
    input [3:0] A,
    input [3:0] B,
    input [2:0] ALU_Sel,
    output reg [3:0] ALU_Out
);
    wire [3:0] sum, and_out, xor_out, and_out_1;
    wire [3:0] shift_left, shift_right, rotate_right;
    wire [3:0] carry;
    wire s;
    reg en1, en2, en3, en4, en5;

    // Subtraction control
    assign s = ALU_Sel[0];

    // Enable control logic for each operation based on ALU_Sel
    always @(*) begin
        en1 = (ALU_Sel == 3'b000) | (ALU_Sel == 3'b001); // Enable for addition and subtraction
        en2 = en1;                                        // Enable for carry calculation
        en3 = (ALU_Sel == 3'b010) | (ALU_Sel == 3'b110); // Enable for AND operations
        en4 = (ALU_Sel == 3'b100);                       // Enable for XOR operation
        en5 = (ALU_Sel == 3'b101) | (ALU_Sel == 3'b011) | (ALU_Sel == 3'b111); // Enable for shifts and rotation
    end

    // Full adder instantiation for 4-bit operation with latches
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : full_adder_gen
            latch_based_full_adder fa (
                .A(A[i]),
                .B(s ? ~B[i] : B[i]),  // Invert B for subtraction
                .X(i == 0 ? s : carry[i-1]),  // Use s as initial carry for subtraction
                .en1(en1),
                .en2(en2),
                .sum(sum[i]),
                .carry_out(carry[i]),
                .A_AND_B(and_out[i]),
                .A_XOR_B(xor_out[i]),
                .A_AND_B_internal(and_out_1[i]) 
            );
        end
    endgenerate

    // Shift and rotate operations, with enable control
    assign shift_left = en5 ? (A << 1) : 0;
    assign shift_right = en5 ? (A >> 1) : 0;
    assign rotate_right = en5 ? {A[0], A[3:1]} : 0;

    // Main ALU output logic
    always @(*) begin
        case (ALU_Sel)
            3'b000: ALU_Out = sum;              // Addition
            3'b001: ALU_Out = sum;              // Subtraction (sum with 2's complement B)
            3'b010: ALU_Out = and_out;          // A AND B (LSB only)
            3'b110: ALU_Out = and_out_1;        // A AND B
            3'b100: ALU_Out = xor_out;          // A XOR B
            3'b101: ALU_Out = shift_left;       // Shift left A
            3'b011: ALU_Out = shift_right;      // Shift right A
            3'b111: ALU_Out = rotate_right;     // Rotate right A
            default: ALU_Out = 4'b0000;         // Default case
        endcase
    end
endmodule

// Testbench
timescale 1ns / 1ps

module alu_tb;
    reg [3:0] A, B;
    reg [2:0] ALU_Sel;
    wire [3:0] ALU_Out;

    latch_based_alu uut (
        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .ALU_Out(ALU_Out)
    );

    initial begin
        A = 0;
        B = 0;
        ALU_Sel = 0;

        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        $monitor("Time=%0t A=%b B=%b ALU_Sel=%b ALU_Out=%b", $time, A, B, ALU_Sel, ALU_Out);

        #100;

        // Test all operations
        A = 4'b1100; B = 4'b0010;
        ALU_Sel = 3'b000; #10; // Addition
        ALU_Sel = 3'b001; #10; // Subtraction
        ALU_Sel = 3'b010; #10; // A'AND B
        ALU_Sel = 3'b011; #10; // A AND B (LSB only)
        ALU_Sel = 3'b100; #10; // A XOR B
        ALU_Sel = 3'b101; #10; // Shift left A
        ALU_Sel = 3'b110; #10; // Shift right A
        ALU_Sel = 3'b111; #10; // Rotate right A

        A = 4'b1111; B = 4'b0001;
        ALU_Sel = 3'b000; #10; 
        ALU_Sel = 3'b001; #10; 

        // More test cases
        A = 4'b0011; B = 4'b0011;
        ALU_Sel = 3'b010; #10; // A AND B
        ALU_Sel = 3'b100; #10; // A XOR B

        A = 4'b1000; B = 4'b0000;
        ALU_Sel = 3'b101; #10; // Shift left A
        ALU_Sel = 3'b110; #10; // Shift right A
        ALU_Sel = 3'b111; #10; // Rotate right A

        #10 $finish;
    end
endmodule
