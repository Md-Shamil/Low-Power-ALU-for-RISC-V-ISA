// Full adder module  
module full_adder(
    input A,
    input B,
    input X,
    output sum,
    output carry_out,
    output A_AND_B,
    output A_XOR_B,
    output A_AND_B_internal
);
   
    assign A_XOR_B = A ^ B;
    assign A_AND_B_internal = A & B;
    assign sum = A_XOR_B ^ X;
    assign carry_out = (A_XOR_B & X) | A_AND_B_internal;
    assign A_AND_B = ~A & B;
endmodule
// ALU module
module alu(
    input [3:0] A,
    input [3:0] B,
    input [2:0] ALU_Sel,
    output reg [3:0] ALU_Out
);
    wire [3:0] sum, and_out,and_out_1, xor_out;
    wire [3:0] shift_left, shift_right, rotate_right;
    wire [3:0] carry;
    wire s;

    // Subtraction control
    assign s = ALU_Sel[0];

    // Full adder instantiation for 4-bit operation
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : full_adder_gen
            full_adder fa(
                .A(A[i]),
                .B(s ? ~B[i] : B[i]),  // Invert B for subtraction
                .X(i == 0 ? s : carry[i-1]),  // Use s as initial carry for subtraction
                .sum(sum[i]),
                .carry_out(carry[i]),
                .A_AND_B(and_out[i]),
                .A_XOR_B(xor_out[i]),
                .A_AND_B_internal(and_out_1[i]) 
            );

        end
    endgenerate

    // Shift and rotate operations
    assign shift_left = A << 1;
    assign shift_right = A >> 1;
    assign rotate_right = {A[0], A[3:1]};

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

    alu uut (
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
