module mul_exec1(rs_index,rs1_data,rs2_data,func,rob_ind,clk1,clk2,rd,ex_b);
input [7:0]rs1_data;
input [7:0]rs2_data;
input [3:0]func,rd;
input [2:0]rob_ind,rs_index;
input clk1,clk2,ex_b;
integer count_md, temp, temp1;
reg[15:0] out1;
always @(posedge clk1)
begin
    if (ex_b == 1)
    begin
        count_md = 0;
        case(func)
            4'b0010:
            begin
                out1 <= #60 rs1_data*rs2_data;
                count_md <=  #61 1;
                tomasulo.ROB[rob_ind][2] <= #60 rs1_data*rs2_data;
                tomasulo.regbank[rd][1] <= #60 16'b1000;
                tomasulo.regbank[rd][0] <= #60 rs1_data*rs2_data;
                tomasulo.mul_array[rs_index][6] <= #60 0;
                tomasulo.pr3_exec_b[2] <= #60 0; //Making the mul exec free
                tomasulo.pr3_mulcount <= #60 tomasulo.pr3_mulcount - 1;
                #62;  //Delay for displaying the data
            end
            4'b0011:
            begin
                out1 <= #80 rs1_data/rs2_data;
                count_md <=  #80 1;
                tomasulo.ROB[rob_ind][2] <= #80 rs1_data/rs2_data;
                tomasulo.regbank[rd][1] <= #80 16'b1000;
                tomasulo.regbank[rd][0] <= #80 rs1_data/rs2_data;
                tomasulo.mul_array[rs_index][6] <= #80 0;
                tomasulo.pr3_exec_b[2] <= #80 0; //Making the mul exec free
                tomasulo.pr3_mulcount <= #80 tomasulo.pr3_mulcount - 1;
                #82;
            end
        endcase

        for(temp = 0; temp <3 && (count_md == 1) ;temp ++)
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

        for(temp = 0; temp <3 && (count_md == 1);temp ++)
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
        if(count_md == 1)
        begin
            $display("\nExec unit 3 : \n");
            $display("rs1_data = %b, rs2_data = %b, funct = %b, rob_ind = %b,out = %b",rs1_data,rs2_data,func,rob_ind,out1);
        end
        end
end

endmodule
