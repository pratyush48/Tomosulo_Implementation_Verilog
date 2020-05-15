
module Rstation_append(rs1,rs2,rob_ind,func,clk1);

input [4:0] rs1,rs2,func;
input [2:0] rob_ind;
// input [7:0] addr;
input clk1;
// output [15:0] out;

always @(posedge clk1)
  begin
      if (func == 4'b0000) begin
          tomasulo.add_array[tomasulo.add_count][] = ;
      end
      else if (!STATUS) begin
          q = newstatus ;
          STATUS = hold ;
      end
      else if (!STATUS) begin
          q = newstatus ;
          STATUS = hold ;
      end
      else if (!STATUS) begin
          q = newstatus ;
          STATUS = hold ;
      end
      else if (!READ) begin
          out = newvalue ;
      end
  end
endmodule
