
module tomasulo_tb;

reg[3:0] pc;
reg clk1,clk2;
integer  k;

 tomasulo tomas(
  .pc(pc),
  .clk1(clk1),
  .clk2(clk2)
  );

initial begin
  $dumpfile("tomasulo_tb.vcd");
  $dumpvars(0,tomasulo_tb);
  clk1 = 0; clk2 = 0; pc = 0;
  repeat(6)
    begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;
    end
end

//Initialising all the registers
initial begin
  for(k = 0;k < 16; k++)
      tomas.regbank[k][0] = k;
end

always @(posedge clk1)
    pc += 4'b1;
// initial
//   repeat(6)
//     begin
//       #20 pc = pc + 4'b1;
//     end

endmodule
