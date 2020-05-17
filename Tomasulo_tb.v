
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
  for(k = 0;k < 8;k++)
      tomas.ROB[k][1] = 8;
  tomas.add_count = 0;
  tomas.mul_count = 2'b0;
  tomas.bch_count = 2'b0;
  tomas.head_p = 3'b0;
  tomas.tail_p = 3'b0;
  tomas.pr3_addexec = 0;
  tomas.pr3_mulexec = 0;
end

always @(posedge clk2)
    pc += 4'b1;
// initial
//   repeat(6)
//     begin
//       #20 pc = pc + 4'b1;
//     end

endmodule
