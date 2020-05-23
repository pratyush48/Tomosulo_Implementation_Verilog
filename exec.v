module exec(rs_index,rs1_data,rs2_data,func,rob_ind,clk1,clk2,rd,exec_b);
input [7:0]rs1_data;
input [7:0]rs2_data;
input [3:0]func,rd;
input [2:0]rob_ind,rs_index;
input clk1,clk2,exec_b;
integer count_as;
integer count_md, temp;
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
                tomasulo.regbank[rd][1] = 8;
                tomasulo.regbank[rd][0] = out1;
                tomasulo.add_array[rs_index][8] = 0;
                tomasulo.pr3_addexec = 0;
            end
            4'b0001:
            begin
                out1 = rs1_data - rs2_data;
                count_as =  1;
                // tomasulo.pr3_addexec = 0;
                tomasulo.ROB[rob_ind][2] = out1;
                tomasulo.regbank[rd][1] = 8;
                tomasulo.regbank[rd][0] = out1;
                tomasulo.add_array[rs_index][8] = 0;
                tomasulo.pr3_addexec = 0;
            end
            4'b0010:
            begin
                out1 = rs1_data*rs2_data;
                count_md =  1;
                // tomasulo.pr3_mulexec = 0;
                tomasulo.ROB[rob_ind][2] = out1;
                tomasulo.regbank[rd][1] =  8;
                tomasulo.regbank[rd][0] = out1;
                tomasulo.mul_array[rs_index][8] = 0;
                tomasulo.pr3_mulexec = 0;

            end
                4'b0011:
            begin
                out1 = rs1_data/rs2_data;
                count_md = 1;
                // tomasulo.pr3_mulexec = 0;
                tomasulo.ROB[rob_ind][2] = out1;
                tomasulo.regbank[rd][1] = 8;
                tomasulo.regbank[rd][0] = out1;
                tomasulo.mul_array[rs_index][8] = 0;
                tomasulo.pr3_mulexec = 0;
            end
            4'b0100:
            begin
                //out1 <= tomasulo.memory[rs1_data+rs2_data];
                //count <= 1;
            end
            4'b0101:
            begin
                //tomasulo.memory[rs1_data+rs2_data] <= tomasulo.regbank[rd][0];
                //count <= 1;
            end

            //4'b0110: out =
        endcase
        for(temp = 0; temp <3 ;temp ++)
        begin
            if(tomasulo.add_array[temp][6] == 0)
                begin
                    if(tomasulo.ROB[tomasulo.add_array[temp][1]][1] == rd)
                        begin
                            tomasulo.add_array[temp][2] = rd;
                            tomasulo.add_array[temp][6] = 1;
                        end
                end
            if(tomasulo.add_array[temp][7] == 0)
                begin
                    if(tomasulo.ROB[tomasulo.add_array[temp][3]][1] == rd)
                        begin
                            tomasulo.add_array[temp][4] = rd;
                            tomasulo.add_array[temp][7] = 1;
                        end
                end
        end
        for(temp = 0; temp <3 ;temp ++)
        begin
            if(tomasulo.mul_array[temp][6] == 0)
                begin
                $display("value of mul RS: %b and %b and %b and %b",tomasulo.mul_array[temp][1],tomasulo.mul_array[temp][3],tomasulo.ROB[tomasulo.mul_array[temp][1]][1],rd);
                    if(tomasulo.ROB[tomasulo.mul_array[temp][1]][1] == rd)
                        begin
                            tomasulo.mul_array[temp][2] = rd;
                            tomasulo.mul_array[temp][6] = 1;
                        end
                end
            if(tomasulo.mul_array[temp][7] == 0)
                begin
                $display("value of mul RS: %b and %b and %b and %b",tomasulo.mul_array[temp][1],tomasulo.mul_array[temp][3],tomasulo.ROB[tomasulo.mul_array[temp][3]][1],rd);
                    if(tomasulo.ROB[tomasulo.mul_array[temp][3]][1] == rd)
                        begin
                            tomasulo.mul_array[temp][4] = rd;
                            tomasulo.mul_array[temp][7] = 1;
                        end
                end
        end
    end
    $display("rs1_data = %b, rs2_data = %b, funct = %b, rob_ind = %b, exec_b = %b,out = %b",rs1_data,rs2_data,func,rob_ind,exec_b,out1);
end

endmodule
