
module Rstation_append(rs1,rs2,rob_ind,func,clk1,clk2,rd,count);

//These 2 bits are two check if the registers are available or not
input count;
input[3:0] rs1,rs2,func,rd;
input [2:0] rob_ind;
reg rs1_b,rs2_b;
reg [3:0] ex_b;
input clk1,clk2;
integer temp,temp2,temp3,temp4,temp5;
integer add_index,mul_index, exec_count;

//RS coulmns: func,rs1,rs2,rob,rs1b,rs2b,busy,exec_busy
//if rs1_b is 1 then it is available

always @(posedge clk2)
  begin
      //Checking for the availability of data in registers
      if(tomasulo.regbank[rs1][1] < 16'b1000)
          rs1_b = 0;
      else
          rs1_b = 1;

      if(tomasulo.regbank[rs2][1] < 16'b1000)
          rs2_b = 0;
      else
          rs2_b = 1;


      for(temp4 = 0; temp4 <= 2; temp4++)
      begin
        if((func == 4'b0000)||(func == 4'b0001))
        begin
          if(tomasulo.add_array[temp4][6] == 0)
          begin
                add_index = temp4;
                temp4 = 5;
              end
          end
        else if((func == 4'b0010)||(func == 4'b0011))
        begin
          if(tomasulo.mul_array[temp4][6] == 0)
          begin
                mul_index = temp4;
                temp4 = 5;
          end
        end
      end
      if (count == 1)
      begin
        // $display("Reservation Station: ");
        //This is for add and sub
        if ((func == 4'b0000)||(func == 4'b0001))
        begin
            tomasulo.add_array[add_index][0] <= func;
            tomasulo.add_array[add_index][1] <= rs1;
            tomasulo.add_array[add_index][2] <= rs2;
            tomasulo.add_array[add_index][3] <= rob_ind;
            tomasulo.add_array[add_index][4] <= rs1_b;
            tomasulo.add_array[add_index][5] <= rs2_b;
            tomasulo.add_array[add_index][6] <= 1;
            tomasulo.add_array[add_index][7] <= 0;
        end
        //This is for multiplication and div
        else if ((func == 4'b0010)||(func == 4'b0011))
        begin
            tomasulo.mul_array[mul_index][0] <= func;
            tomasulo.mul_array[mul_index][1] <= rs1;
            tomasulo.mul_array[mul_index][2] <= rs2;
            tomasulo.mul_array[mul_index][3] <= rob_ind;
            tomasulo.mul_array[mul_index][4] <= rs1_b;
            tomasulo.mul_array[mul_index][5] <= rs2_b;
            tomasulo.mul_array[mul_index][6] <= 1;
            tomasulo.mul_array[mul_index][7] <= 0;
        end
        //This is for branch
        else if ((func == 4'b0110)||(func == 4'b0111))
        begin
            tomasulo.add_array[add_index][0] <= func;
            tomasulo.add_array[add_index][1] <= rs1;
            tomasulo.add_array[add_index][2] <= rs2;
            tomasulo.add_array[add_index][3] <= rob_ind;
            tomasulo.add_array[add_index][4] <= rs1_b;
            tomasulo.add_array[add_index][5] <= rs2_b;
        end
        //This is for load and store
        else if ((func == 4'b0100)||(func == 4'b0101))
        begin
            tomasulo.add_array[tomasulo.add_count][0] <= func;
            tomasulo.add_array[tomasulo.add_count][1] <= rs1;
            tomasulo.add_array[tomasulo.add_count][2] <= rs2;
            tomasulo.add_array[tomasulo.add_count][3] <= rob_ind;
            tomasulo.add_array[tomasulo.add_count][4] <= rs1_b;
            tomasulo.add_array[tomasulo.add_count][5] <= rs2_b;
        end
      end
  end

always @(posedge clk2)
  begin
    ex_b = 4'b0000;   //Making all exec units busy

    //For add and mult exec units
    for(temp2 = 0; temp2 < 3; temp2++)
    begin
    // $display("rs1b = %b rs2_b = %b,add_exec = %b",tomasulo.add_array[temp2][4],tomasulo.add_array[temp2][5],tomasulo.pr3_addexec);
      if((tomasulo.add_array[temp2][4] == 3'b1) && (tomasulo.add_array[temp2][5] == 3'b1) && (tomasulo.add_array[temp2][6] == 1) && (tomasulo.pr3_addcount < 2) && (tomasulo.add_array[temp2][7] == 0))
      begin
        if(tomasulo.pr3_exec_b[0] == 0)
        begin
            tomasulo.pr3_rsindex[0] <= temp2;
            tomasulo.pr3_rs1data[0] <= tomasulo.regbank[tomasulo.add_array[temp2][1]][0];
            tomasulo.pr3_rs2data[0] <= tomasulo.regbank[tomasulo.add_array[temp2][2]][0];
            tomasulo.pr3_func[0] <=  tomasulo.add_array[temp2][0];
            tomasulo.pr3_rob_ind[0] <= tomasulo.add_array[temp2][3];
            tomasulo.pr3_rd[0] <= tomasulo.ROB[tomasulo.add_array[temp2][3]][1];
            tomasulo.add_array[temp2][7] <= 1; //To know that the inst is in exec stage
            ex_b[0] <= 1;
            tomasulo.pr3_exec_b[0] <= 1;
            tomasulo.pr3_addcount += 1;
        end
        else if(tomasulo.pr3_exec_b[1] == 0)
        begin
            tomasulo.pr3_rsindex[1] <= temp2;
            tomasulo.pr3_rs1data[1] <= tomasulo.regbank[tomasulo.add_array[temp2][1]][0];
            tomasulo.pr3_rs2data[1] <= tomasulo.regbank[tomasulo.add_array[temp2][2]][0];
            tomasulo.pr3_func[1] <=  tomasulo.add_array[temp2][0];
            tomasulo.pr3_rob_ind[1] <= tomasulo.add_array[temp2][3];
            tomasulo.pr3_rd[1] <= tomasulo.ROB[tomasulo.add_array[temp2][3]][1];
            tomasulo.add_array[temp2][7] <= 1; //To know that the instruction is in exec stage
            ex_b[1] <= 1;
            tomasulo.pr3_exec_b[1] <= 1;
            tomasulo.pr3_addcount += 1;
        end
      end
    end
    //For multiplication and division exec units
    for(temp3 = 0; temp3 < 3; temp3++)
    begin
      if((tomasulo.mul_array[temp3][4] == 3'b1) && (tomasulo.mul_array[temp3][5] == 3'b1) && (tomasulo.mul_array[temp3][6] == 1) && (tomasulo.pr3_mulcount < 2) && (tomasulo.mul_array[temp3][7] == 0))
      begin
        if(tomasulo.pr3_exec_b[2] == 0)
          begin
            tomasulo.pr3_rsindex[2] <= temp3;
            tomasulo.pr3_rs1data[2] <= tomasulo.regbank[tomasulo.mul_array[temp3][1]][0];
            tomasulo.pr3_rs2data[2] <= tomasulo.regbank[tomasulo.mul_array[temp3][2]][0];
            tomasulo.pr3_func[2] <=  tomasulo.mul_array[temp3][0];
            tomasulo.pr3_rob_ind[2] <= tomasulo.mul_array[temp3][3];
            tomasulo.pr3_rd[2] <= tomasulo.ROB[tomasulo.mul_array[temp3][3]][1];
            tomasulo.mul_array[temp3][7] <= 1;
            ex_b[2] <= 1;
            tomasulo.pr3_exec_b[2] <= 1;
            tomasulo.pr3_mulcount += 1;
          end
        else if(tomasulo.pr3_exec_b[3] == 0)
          begin
            tomasulo.pr3_rsindex[3] <= temp3;
            tomasulo.pr3_rs1data[3] <= tomasulo.regbank[tomasulo.mul_array[temp3][1]][0];
            tomasulo.pr3_rs2data[3] <= tomasulo.regbank[tomasulo.mul_array[temp3][2]][0];
            tomasulo.pr3_func[3] <=  tomasulo.mul_array[temp3][0];
            tomasulo.pr3_rob_ind[3] <= tomasulo.mul_array[temp3][3];
            tomasulo.pr3_rd[3] <= tomasulo.ROB[tomasulo.mul_array[temp3][3]][1];
            tomasulo.mul_array[temp3][7] <= 1;
            ex_b[3] <= 1;
            tomasulo.pr3_exec_b[3] <= 1;
            tomasulo.pr3_mulcount += 1;
          end
      end
    end
  //RS coulmns: func,rs1,rs2,rob,rs1b,rs2b,busy
  #3;
  $display("Reservation Station: ");
  // $display("add_count = %d, mul_count = %d, exec_b = %b, pr3_execb = %b",tomasulo.pr3_addcount,tomasulo.pr3_mulcount,ex_b,tomasulo.pr3_exec_b);
  $display("\nMULT and DIV RS");
  for(temp = 0;temp <= 2;temp++)
    $display("Funct = %b, rs1_b = %b rs2_b = %b, busybit = %b, RS_exec = %b",tomasulo.mul_array[temp][0],tomasulo.mul_array[temp][4],tomasulo.mul_array[temp][5],tomasulo.mul_array[temp][6],tomasulo.mul_array[temp][7]);
  $display("\nADD and SUB RS");
  for(temp = 0;temp <= 2;temp++)
    $display("Funct = %b, rs1_b = %b rs2_b = %b, busybit = %b,  RS_exec = %b",tomasulo.add_array[temp][0],tomasulo.add_array[temp][4],tomasulo.add_array[temp][5],tomasulo.add_array[temp][6],tomasulo.add_array[temp][7]);

  end

add_exec1 ex1(tomasulo.pr3_rsindex[0],tomasulo.pr3_rs1data[0],tomasulo.pr3_rs2data[0],tomasulo.pr3_func[0],tomasulo.pr3_rob_ind[0],clk1,clk2,tomasulo.pr3_rd[0],ex_b[0]);
add_exec2 ex2(tomasulo.pr3_rsindex[1],tomasulo.pr3_rs1data[1],tomasulo.pr3_rs2data[1],tomasulo.pr3_func[1],tomasulo.pr3_rob_ind[1],clk1,clk2,tomasulo.pr3_rd[1],ex_b[1]);
mul_exec1 ex3(tomasulo.pr3_rsindex[2],tomasulo.pr3_rs1data[2],tomasulo.pr3_rs2data[2],tomasulo.pr3_func[2],tomasulo.pr3_rob_ind[2],clk1,clk2,tomasulo.pr3_rd[2],ex_b[2]);
mul_exec2 ex4(tomasulo.pr3_rsindex[3],tomasulo.pr3_rs1data[3],tomasulo.pr3_rs2data[3],tomasulo.pr3_func[3],tomasulo.pr3_rob_ind[3],clk1,clk2,tomasulo.pr3_rd[3],ex_b[3]);
endmodule
