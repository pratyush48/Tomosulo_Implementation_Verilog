module exec(rs_index,rs1_data,rs2_data,func,rob_ind,clk1,clk2,rd,exec_b);
input [7:0]rs1_data;
input [7:0]rs2_data;
input [3:0]func,rd;
input [2:0]rob_ind,rs_index;
input clk1,clk2,exec_b;
integer count_as;
integer count_md, temp, temp1;
reg[15:0] out1;
always @(posedge clk2)
begin
    $display("\nExecution stage : \n");
    if (exec_b == 1)
    begin
        count_as = 0;
        count_md = 0;
        case(func)
            4'b0000:
            begin
                out1 = rs1_data+rs2_data;
                count_as =  1;
                // tomasulo.pr3_addexec = 0;
                tomasulo.ROB[rob_ind][2] =  out1;
                tomasulo.regbank[rd][1] = 16'b1000;
                tomasulo.regbank[rd][0] = out1;
                tomasulo.add_array[rs_index][6] = 0;
                tomasulo.pr3_addexec = 0;
            end
            4'b0001:
            begin
                out1 = rs1_data - rs2_data;
                count_as =  1;
                // tomasulo.pr3_addexec = 0;
                tomasulo.ROB[rob_ind][2] = out1;
                tomasulo.regbank[rd][1] = 16'b1000;
                tomasulo.regbank[rd][0] = out1;
                tomasulo.add_array[rs_index][6] = 0;
                tomasulo.pr3_addexec = 0;
            end
            4'b0010:
            begin
                out1 = rs1_data*rs2_data;
                count_md =  1;
                // tomasulo.pr3_mulexec = 0;
                tomasulo.ROB[rob_ind][2] = out1;
                tomasulo.regbank[rd][1] =  16'b1000;
                tomasulo.regbank[rd][0] = out1;
                tomasulo.mul_array[rs_index][6] = 0;
                tomasulo.pr3_mulexec = 0;

            end
                4'b0011:
            begin
                out1 = rs1_data/rs2_data;
                count_md = 1;
                // tomasulo.pr3_mulexec = 0;
                tomasulo.ROB[rob_ind][2] = out1;
                tomasulo.regbank[rd][1] = 16'b1000;
                tomasulo.regbank[rd][0] = out1;
                tomasulo.mul_array[rs_index][6] = 0;
                tomasulo.pr3_mulexec = 0;
            end
            // 4'b0100:
            // begin
            //     //out1 <= tomasulo.memory[rs1_data+rs2_data];
            //     //count <= 1;
            // end
            // 4'b0101:
            // begin
            //     //tomasulo.memory[rs1_data+rs2_data] <= tomasulo.regbank[rd][0];
            //     //count <= 1;
            // end

            //4'b0110: out =
        endcase

        for(temp = 0; temp <3 ;temp ++)
        begin
            if(tomasulo.add_array[temp][4] == 0)
                begin
                    if(tomasulo.add_array[temp][1] == rd)
                        tomasulo.add_array[temp][4] = 1;
                end
            if(tomasulo.add_array[temp][5] == 0)
                begin
                    if(tomasulo.add_array[temp][2] == rd)
                        tomasulo.add_array[temp][5] = 1;
                end
        end
        for(temp1 = 0; temp1 <3 ;temp1 ++)
        begin
        $display("value of mul RS: rs1b bit is %b\t %b and %b",tomasulo.mul_array[temp1][4], tomasulo.mul_array[temp1][1] ,rd);
            if(tomasulo.mul_array[temp1][4] == 0)
                begin
                    if(tomasulo.mul_array[temp1][1] == rd)
                        tomasulo.mul_array[temp1][4] = 1;
                end
        $display("value of mul RS: rs2b bit is %b\t %b and %b",tomasulo.mul_array[temp1][5], tomasulo.mul_array[temp1][2] ,rd);
            if(tomasulo.mul_array[temp1][5] == 0)
                begin
                    if(tomasulo.mul_array[temp1][2] == rd)
                        tomasulo.mul_array[temp1][5] = 1;
                end
        end
    end
    $display("rs1_data = %b, rs2_data = %b, funct = %b, rob_ind = %b, exec_b = %b,out = %b",rs1_data,rs2_data,func,rob_ind,exec_b,out1);
end

endmodule

// Understood the mistake. It is that in issue, we have to check all the dependecies every time.
//like when third ins was executed, mul r11 ins was not fetched so it could not check for dependecy in execute stage
//In some stage, we have to check for all dependencies..
