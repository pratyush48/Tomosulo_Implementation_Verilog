module add_exec2(rs_index,rs1_data,rs2_data,func,rob_ind,clk1,clk2,rd,ex_b);
input [7:0]rs1_data;
input [7:0]rs2_data;
input [3:0]func,rd;
input [2:0]rob_ind,rs_index;
input clk1,clk2,ex_b;
integer count_as;
integer count_md, temp, temp1;
reg[15:0] out1;
always @(posedge clk2)
begin
    if (ex_b == 1)
    begin
        count_as = 0;
        count_md = 0;
        case(func)
            4'b0000:
            begin
                out1 = rs1_data+rs2_data;
                count_as =  1;
                // tomasulo.pr3_addexec = 0;
                tomasulo.ROB[rob_ind][2] <=  out1;
                tomasulo.regbank[rd][1] <= 16'b1000;
                tomasulo.regbank[rd][0] <= out1;
                tomasulo.add_array[rs_index][6] <= 0;
                tomasulo.pr3_exec_b[1] = 0; //Making it free
                tomasulo.pr3_addcount -= 1;
            end
            4'b0001:
            begin
                out1 = rs1_data - rs2_data;
                count_as =  1;
                // tomasulo.pr3_addexec = 0;
                tomasulo.ROB[rob_ind][2] <= out1;
                tomasulo.regbank[rd][1] <= 16'b1000;
                tomasulo.regbank[rd][0] <= out1;
                tomasulo.add_array[rs_index][6] <= 0;
                tomasulo.pr3_exec_b[1] = 0; //Making it free
                tomasulo.pr3_addcount -= 1;
            end
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
        for(temp = 0; temp <3 ;temp ++)
        begin
            if(tomasulo.mul_array[temp][4] == 0)
                begin
                    if(tomasulo.mul_array[temp][1] == rd)
                        tomasulo.mul_array[temp][4] = 1;
                end
            if(tomasulo.mul_array[temp][5] == 0)
                begin
                    if(tomasulo.mul_array[temp][2] == rd)
                        tomasulo.mul_array[temp][5] = 1;
                end
        end
    $display("\nExec unit 2 : \n");
    $display("rs1_data = %b, rs2_data = %b, funct = %b, rob_ind = %b,out = %b",rs1_data,rs2_data,func,rob_ind,out1);
    end
end

endmodule
