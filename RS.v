
module Rstation_append(rs1_b,rs2_b,rs1,rs2,rob_ind,func,clk1,clk2,rd,count);

//These 2 bits are two check if the registers are available or not
input rs1_b,rs2_b,count;
input[3:0] rs1,rs2,func,rd;
input [2:0] rob_ind;
// input [7:0] addr;
input clk1,clk2;
integer temp;
// output [15:0] out;

//RS coulmns: func,rob_rs1,rs1,rob_rs2,rs2,rob
//if rs1_b is 1 then it is available

always @(posedge clk2)
  begin
      if (count == 1)
      begin
        //This is for add and sub
        if ((func == 4'b0000)||(func == 4'b0001)) begin
            tomasulo.add_array[tomasulo.add_count][0] <= func;
            tomasulo.add_array[tomasulo.add_count][1+rs1_b] <= rs1;
            tomasulo.add_array[tomasulo.add_count][3+rs2_b] <= rs2;
            tomasulo.add_array[tomasulo.add_count][5] <= rob_ind;
        end
        //This is for multiplication and div
        else if ((func == 4'b0010)||(func == 4'b0011)) begin
            tomasulo.mul_array[tomasulo.mul_count][0] <= func;
            tomasulo.mul_array[tomasulo.mul_count][1+rs1_b] <= rs1;
            tomasulo.mul_array[tomasulo.mul_count][3+rs2_b] <= rs2;
            tomasulo.mul_array[tomasulo.mul_count][5] <= rob_ind;
        end
        //This is for branch
        else if ((func == 4'b0110)||(func == 4'b0111)) begin
            tomasulo.add_array[tomasulo.add_count][0] <= func;
            tomasulo.add_array[tomasulo.add_count][1+rs1_b] <= rs1;
            tomasulo.add_array[tomasulo.add_count][3+rs2_b] <= rs2;
            tomasulo.add_array[tomasulo.add_count][5] <= rob_ind;
        end
        //This is for load and store
        else if ((func == 4'b0100)||(func == 4'b0101)) begin
            tomasulo.add_array[tomasulo.add_count][0] <= func;
            tomasulo.add_array[tomasulo.add_count][1+rs1_b] <= rs1;
            tomasulo.add_array[tomasulo.add_count][3+rs2_b] <= rs2;
            tomasulo.add_array[tomasulo.add_count][5] <= rob_ind;
        end
    end
  end
always @(posedge clk2)
  begin
  // checking the first column of RS
  for(temp = 0;temp < 3;temp++)
    $display("Columns of add_rs = %b",tomasulo.add_array[temp][0]);
  for(temp = 0;temp < 3;temp++)
    $display("Columns of mul_rs = %b",tomasulo.mul_array[temp][0]);
  end

endmodule
