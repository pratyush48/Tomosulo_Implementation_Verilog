
module tomasulo_tb;

reg[3:0] pc;
reg clk1,clk2;
integer  k;

 tomasulo uut(
  .pc(pc),
  .clk1(clk1),
  .clk2(clk2)
  );

initial begin
  $dumpfile("tomasulo_tb.vcd");
  $dumpvars(0,tomasulo_tb);
  clk1 = 0; clk2 = 0; pc = 0;
  repeat(20)
    begin
      #5 clk1 = 1; #5 clk2 = 0;
      #5 clk2 = 1; #5 clk2 = 0;
    end
end

//Initialising all the registers
initial begin
  for(k = 0;k < 16; k++)
      tomasulo.regbank[k] = k;
end

initial
  repeat(8)
    begin
      #20 PC += 4'b1;
    end

endmodule
