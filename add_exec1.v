module add_exec1(rs_index,rs1_data,rs2_data,func,rob_ind,clk1,clk2,rd,ex_b);
input [7:0]rs1_data;
input [7:0]rs2_data;
input [3:0]func,rd;
input [2:0]rob_ind,rs_index;
input clk1,clk2,ex_b;
integer count_as;
integer  temp, temp1;
reg[15:0] out1;

// add = 2cyles (40units)
// sub = 2cyles (40units)
// mul = 3cyles (60units)
// add = 4cyles (80units)

always @(posedge clk1)
begin
    if (ex_b == 1)
    begin
        count_as = 0;
        case(func)
            4'b0000:
            begin
                out1 <= #40 rs1_data+rs2_data;
                count_as <= #40 1;
                // tomasulo.pr3_addexec = 0;
                tomasulo.ROB[rob_ind][2] <= #40 out1;
                tomasulo.regbank[rd][1] <= #40 16'b1000;
                tomasulo.regbank[rd][0] <= #40 out1;
                tomasulo.add_array[rs_index][6] <= #40 0;
                tomasulo.pr3_exec_b[0] <= #40 0; //Making it free
                tomasulo.pr3_addcount <= #40 tomasulo.pr3_addcount - 1;
                #42
                $display("count_as in exec unit 1 =\t\t\t\t %b",count_as);
            end
            4'b0001:
            begin
                out1 <= #40 rs1_data - rs2_data;
                count_as <= #40 1;
                // tomasulo.pr3_addexec = 0;
                tomasulo.ROB[rob_ind][2] <= #40 out1;
                tomasulo.regbank[rd][1] <= #40 16'b1000;
                tomasulo.regbank[rd][0] <= #40 out1;
                tomasulo.add_array[rs_index][6] <= #40 0;
                tomasulo.pr3_exec_b[0] <= #40 0; //Making it free
                tomasulo.pr3_addcount <= #40 tomasulo.pr3_addcount - 1;
                #42
                $display("count_as in exec unit 1 =\t\t\t\t %b",count_as);
            end
        endcase

        for(temp = 0; temp <3 && (count_as == 1);temp ++)
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
        for(temp = 0; temp <3 && (count_as == 1) ;temp ++)
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
    if(count_as == 1)
    begin
        $display("\nExec unit 1 : \n");
        $display("rs1_data = %b, rs2_data = %b, funct = %b, rob_ind = %b,out = %b",rs1_data,rs2_data,func,rob_ind,out1);
    end
    end
end

endmodule
