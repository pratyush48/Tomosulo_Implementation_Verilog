//This is the instruction set which takes the PC number and gives the instruction in that memory.

module instruction_set(PC,clk1,output_instruction);

input [4:0] PC;
input clk1;
output reg [15:0] output_instruction;
integer num;

//These are the instructions that we use for matrix multiplication.

initial begin
    //mul r3 r1 r2
    //add r5 r3 r4
    //add r10 r8 r9
    //mul r11 r7 r10
    //div r8 r6 r3     0011011000111000
    //sub r6 r11 r8    0001101110000110

    tomasulo.memory[0] = 16'b0010000100100011;
    tomasulo.memory[1] = 16'b0000001101000101;
    tomasulo.memory[2] = 16'b0000100010011010;
    tomasulo.memory[3] = 16'b0010011110101011;
    tomasulo.memory[4] = 16'b0011011000111000;
    tomasulo.memory[5] = 16'b0001101101010110;

    // add r5,r4,r4
    // mul r2,r1,r3
    // div r10,r5,r2
    // add r12,r4,r6
    // sub r5,r14,r2

    // tomasulo.memory[0] = 16'b0000010001000101;
    // tomasulo.memory[1] = 16'b0010000100110010;
    // tomasulo.memory[2] = 16'b0011010100101010;
    // tomasulo.memory[3] = 16'b0000010001101100;
    // tomasulo.memory[4] = 16'b0001111000100101;

end

always@(posedge clk1)
  begin
    num = PC;
    output_instruction = tomasulo.memory[num];  //Here we are assigning the instruction present in the memory.
  end


endmodule
