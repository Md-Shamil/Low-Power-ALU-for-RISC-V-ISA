module ALU_4bit (
    input [3:0] A,           // 4-bit input A
    input [3:0] B,           // 4-bit input B
    input [2:0] ALU_Sel,     // 3-bit ALU selection input
    output reg [3:0] ALU_Out, // 4-bit output result
    output reg CarryOut      // Carry out flag (valid for add/subtract)
);

    always @(*)
    begin
        case (ALU_Sel)
            3'b000: begin
                {CarryOut, ALU_Out} = A + B; // Addition
            end
            3'b001: begin
                {CarryOut, ALU_Out} = A - B; // Subtraction
            end
            3'b010: begin
                ALU_Out = A & B; // AND
                CarryOut = 1'b0; // No carry for AND
            end
            3'b011: begin
                ALU_Out = A | B; // OR
                CarryOut = 1'b0; // No carry for OR
            end
            3'b100: begin
                ALU_Out = A ^ B; // XOR
                CarryOut = 1'b0; // No carry for XOR
            end
            3'b101: begin
                ALU_Out = ~(A | B); // NOR
                CarryOut = 1'b0; // No carry for NOR
            end
            3'b110: begin
                ALU_Out = A << 1; // Logical left shift
                CarryOut = A[3]; // Carry from MSB
            end
            3'b111: begin
                ALU_Out = A >> 1; // Logical right shift
                CarryOut = A[0]; // Carry from LSB
            end
            default: begin
                ALU_Out = 4'b0000; // Default case
                CarryOut = 1'b0;
            end
        endcase
    end
endmodule
module tb_ALU_4bit;
    // Inputs
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] ALU_Sel;

    // Outputs
    wire [3:0] ALU_Out;
    wire CarryOut;

    // Instantiate the ALU
    ALU_4bit uut (
        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .ALU_Out(ALU_Out),
        .CarryOut(CarryOut)
    );

    // Apply test vectors
    initial begin
        // Test Addition
        A = 4'b0001; B = 4'b0010; ALU_Sel = 3'b000;
        #10; // Wait 10 time units
        $display("Addition: A=%b, B=%b, ALU_Out=%b, CarryOut=%b", A, B, ALU_Out, CarryOut);

        // Test Subtraction
        A = 4'b0100; B = 4'b0011; ALU_Sel = 3'b001;
        #10;
        $display("Subtraction: A=%b, B=%b, ALU_Out=%b, CarryOut=%b", A, B, ALU_Out, CarryOut);

        // Test AND
        A = 4'b1100; B = 4'b1010; ALU_Sel = 3'b010;
        #10;
        $display("AND: A=%b, B=%b, ALU_Out=%b, CarryOut=%b", A, B, ALU_Out, CarryOut);

        // Test OR
        A = 4'b0101; B = 4'b0011; ALU_Sel = 3'b011;
        #10;
        $display("OR: A=%b, B=%b, ALU_Out=%b, CarryOut=%b", A, B, ALU_Out, CarryOut);

        // Test XOR
        A = 4'b1101; B = 4'b1011; ALU_Sel = 3'b100;
        #10;
        $display("XOR: A=%b, B=%b, ALU_Out=%b, CarryOut=%b", A, B, ALU_Out, CarryOut);

        // Test NOR
        A = 4'b0001; B = 4'b0010; ALU_Sel = 3'b101;
        #10;
        $display("NOR: A=%b, B=%b, ALU_Out=%b, CarryOut=%b", A, B, ALU_Out, CarryOut);

        // Test Left Shift
        A = 4'b0011; ALU_Sel = 3'b110;
        #10;
        $display("Left Shift: A=%b, ALU_Out=%b, CarryOut=%b", A, ALU_Out, CarryOut);

        // Test Right Shift
        A = 4'b1100; ALU_Sel = 3'b111;
        #10;
        $display("Right Shift: A=%b, ALU_Out=%b, CarryOut=%b", A, ALU_Out, CarryOut);

        // Finish simulation
        $finish;
    end
endmodule


