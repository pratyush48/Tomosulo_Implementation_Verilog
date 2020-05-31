
module tomasulo_tb;

reg[3:0] pc;
reg clk1,clk2;
integer  k;
integer clock_cycle;

tomasulo tomas(
.pc(pc),
.clk1(clk1),
.clk2(clk2)
);

initial begin
  $dumpfile("tomasulo_tb.vcd");
  $dumpvars(0,tomasulo_tb);
  clk1 = 0; clk2 = 0; pc = 0;
  clock_cycle = 0;
  repeat(15)
    begin
      $display("\nCLOCK CYCLE : %d\n",clock_cycle);
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;
      clock_cycle += 1;
    end
end

//Initialising all the registers
initial begin
  for(k = 0;k < 16; k++)
      tomas.regbank[k][0] = k;
  for(k = 0;k < 8;k++)
      tomas.ROB[k][1] = 8;
  for(k = 0;k < 3;k++)
  begin
      tomas.add_array[k][6] = 3'b0;
      tomas.mul_array[k][6] = 3'b0;
      tomas.add_array[k][7] = 3'b0;
      tomas.mul_array[k][7] = 3'b0;
  end
  // for(k = 0; k < 3 ;k++)
      // tomas.bch_array[k][8] = 0;
  tomas.add_count = 0;
  tomas.mul_count = 0;
  tomas.bch_count = 0;
  tomas.head_p = 3'b0;
  tomas.tail_p = 3'b0;
  tomas.pr3_exec_b = 4'b0000;
  tomas.pr3_addcount = 0;
  tomas.pr3_mulcount = 0;
end

always @(posedge clk2) begin
      pc += 4'b1;
    end
// initial
//   repeat(6)
//     begin
//       #20 pc = pc + 4'b1;
//     end

endmodule
