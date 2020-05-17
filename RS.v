
module Rstation_append(rs1_b,rs2_b,rs1,rs2,rob_ind,func,clk1,clk2,rd,count);

//These 2 bits are two check if the registers are available or not
input rs1_b,rs2_b,count;
input[3:0] rs1,rs2,func,rd;
input [2:0] rob_ind;
// input [7:0] addr;
input clk1,clk2;
integer temp,temp2,temp3;
reg exec_b;
// output [15:0] out;

//RS coulmns: func,rob_rs1,rs1,rob_rs2,rs2,rob,busy
//if rs1_b is 1 then it is available

always @(posedge clk2)
  begin
      if (count == 1)
      begin
        //This is for add and sub
        if ((func == 4'b0000)||(func == 4'b0001)) begin
            tomasulo.add_array[tomasulo.add_count-1][0] <= func;
            tomasulo.add_array[tomasulo.add_count-1][2+rs1_b] <= rs1;
            tomasulo.add_array[tomasulo.add_count-1][4+rs2_b] <= rs2;
            tomasulo.add_array[tomasulo.add_count-1][5] <= rob_ind;
            tomasulo.add_array[tomasulo.add_count-1][6] <= rs1_b;
            tomasulo.add_array[tomasulo.add_count-1][7] <= rs2_b;
        end
        //This is for multiplication and div
        else if ((func == 4'b0010)||(func == 4'b0011)) begin
            tomasulo.mul_array[tomasulo.mul_count-1][0] <= func;
            tomasulo.mul_array[tomasulo.mul_count-1][2+rs1_b] <= rs1;
            tomasulo.mul_array[tomasulo.mul_count-1][4+rs2_b] <= rs2;
            tomasulo.mul_array[tomasulo.mul_count-1][5] <= rob_ind;
            tomasulo.mul_array[tomasulo.mul_count-1][6] <= rs1_b;
            tomasulo.mul_array[tomasulo.mul_count-1][7] <= rs2_b;
        end
        //This is for branch
        else if ((func == 4'b0110)||(func == 4'b0111)) begin
            tomasulo.add_array[tomasulo.add_count-1][0] <= func;
            tomasulo.add_array[tomasulo.add_count-1][2+rs1_b] <= rs1;
            tomasulo.add_array[tomasulo.add_count-1][4+rs2_b] <= rs2;
            tomasulo.add_array[tomasulo.add_count-1][5] <= rob_ind;
            tomasulo.add_array[tomasulo.add_count-1][6] <= rs1_b;
            tomasulo.add_array[tomasulo.add_count-1][7] <= rs2_b;
        end
        //This is for load and store
        else if ((func == 4'b0100)||(func == 4'b0101)) begin
            tomasulo.add_array[tomasulo.add_count-1][0] <= func;
            tomasulo.add_array[tomasulo.add_count-1][2+rs1_b] <= rs1;
            tomasulo.add_array[tomasulo.add_count-1][4+rs2_b] <= rs2;
            tomasulo.add_array[tomasulo.add_count-1][5] <= rob_ind;
            tomasulo.add_array[tomasulo.add_count-1][6] <= rs1_b;
            tomasulo.add_array[tomasulo.add_count-1][7] <= rs2_b;
        end
    end
  end

always @(posedge clk2)
  begin
  exec_b = 0;
  for(temp2 = 0; temp2<3; temp2++)
  begin
  // $display("rs1b = %b rs2_b = %b,add_exec = %b",tomasulo.add_array[temp2][6],tomasulo.add_array[temp2][7],tomasulo.pr3_addexec);
    if((tomasulo.add_array[temp2][6] == 3'b1) && (tomasulo.add_array[temp2][7] == 3'b1) && (tomasulo.pr3_addexec == 0) )
    begin
      tomasulo.pr3_rs1data <= tomasulo.regbank[tomasulo.add_array[temp2][3]][0];
      tomasulo.pr3_rs2data <= tomasulo.regbank[tomasulo.add_array[temp2][5]][0];
      tomasulo.pr3_func <=  func;
      tomasulo.pr3_rob_ind <= rob_ind;
      tomasulo.pr3_rd = rd;
      exec_b <= 1;
      tomasulo.pr3_addexec += 1;
    end
  end
  for(temp3 = 0; temp3 < 3; temp3++)
  begin
  // $display("rs1b = %b rs2_b = %b,mul_exec = %b",tomasulo.mul_array[temp3][6],tomasulo.mul_array[temp3][7],tomasulo.pr3_mulexec);
    $display("reg_value = %b",tomasulo.regbank[tomasulo.add_array[temp3][3]][0]);
    if((tomasulo.mul_array[temp3][6] == 3'b1) && (tomasulo.mul_array[temp3][7] == 3'b1) && (tomasulo.pr3_mulexec == 0))
    begin
      tomasulo.pr3_rs1data <= tomasulo.regbank[tomasulo.add_array[temp3][3]][0];
      tomasulo.pr3_rs2data <= tomasulo.regbank[tomasulo.add_array[temp3][5]][0];
      tomasulo.pr3_func <=  func;
      tomasulo.pr3_rob_ind = rob_ind;
      tomasulo.pr3_rd <= rd;
      exec_b <= 1;
      tomasulo.pr3_mulexec += 1;
    end
  end
  // checking the first column of RS
  // #100
  // $display("rs1d = %b,rs2d = %b,func = %b,exec_b = %b",tomasulo.pr3_rs1data,tomasulo.pr3_rs2data,tomasulo.pr3_func,exec_b);
  // for(temp = 0;temp < 2;temp++)
  //   $display("rs1b = %b rs2_b = %b,add_exec = %b",tomasulo.mul_array[temp][6],tomasulo.mul_array[temp][7],tomasulo.pr3_mulexec);
  // for(temp = 0;temp < 2;temp++)
  //   $display("rs1b = %b rs2_b = %b,add_exec = %b",tomasulo.add_array[temp][6],tomasulo.add_array[temp][7],tomasulo.pr3_addexec);

  end
  exec ex(tomasulo.pr3_rs1data,tomasulo.pr3_rs2data,tomasulo.pr3_func,tomasulo.pr3_rob_ind,clk1,tomasulo.pr3_rd,exec_b);

endmodule
