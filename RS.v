
module Rstation_append(out,rs1,rs2,rd,func,addr,clk1,clk2);

input [4:0] rs1,rs2,rd,func;
input [7:0] addr;
input clk1,clk2;
output [15:0] out;
// wire [1:0] add_count,mul_count,bch_count;
initial begin
  // add_array[0][0] = 2'b11;
  //array initialization
  // #20;
  $display("\t array[0] = %b",tomasulo.count);
end

endmodule
