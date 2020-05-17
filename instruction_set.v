//This is the instruction set which takes the PC number and gives the instruction in that memory.

module instruction_set(PC,clk1,output_instruction);

input [31:0] PC;
output reg [31:0] output_instruction;
input clk1;
integer num;

//These are the instructions that we use for matrix multiplication.

initial begin
    tomasulo.memory[0] = 16'b0010000100100011;
    tomasulo.memory[1] = 16'b0000001101000101;
    tomasulo.memory[2] = 16'b0000001001100111;
    tomasulo.memory[3] = 16'b0000100010011010;
    tomasulo.memory[4] = 16'b0010011110101011;
    tomasulo.memory[5] = 16'b0001010110110101;
end

always@(posedge clk1)
  begin
    num = PC;
    output_instruction = tomasulo.memory[num];  //Here we are assigning the instruction present in the memory.
  end


endmodule
