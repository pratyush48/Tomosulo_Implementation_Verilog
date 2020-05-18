module exec(rs_index,rs1_data,rs2_data,func,rob_ind,clk1,clk2,rd,exec_b);
input [7:0]rs1_data;
input [7:0]rs2_data;
input [3:0]func,rd;
input [2:0]rob_ind,rs_index;
input clk1,clk2,exec_b;
integer count_as;
integer count_md;
reg[15:0] out1;
always @(posedge clk2)
begin
    $display("\nExecution stage : \n");
    $display("exec: rob_ind = %b, rd = %b",rob_ind,rd);
    if (exec_b == 1)
    begin
        count_as = 0;
        count_md = 0;
        case(func)
            4'b0000:
            begin
                out1 <= rs1_data+rs2_data;
                count_as <= 1;
                tomasulo.pr3_addexec <= 0;
                tomasulo.ROB[rob_ind][2] =  out1;
                tomasulo.regbank[rd][1] = 8;
            end
            4'b0001:
            begin
                out1 <= #20 rs1_data - rs2_data;
                count_as <= #20 1;
                tomasulo.pr3_addexec <= #20 0;
                tomasulo.ROB[rob_ind][2] = #20 out1;
                tomasulo.regbank[rd][1] = #20 8;
            end
            4'b0010:
            begin
                out1 <= #40 rs1_data*rs2_data;
                count_md <= #40 1;
                tomasulo.pr3_mulexec <= #40 0;
                tomasulo.ROB[rob_ind][2] = #40 out1;
                tomasulo.regbank[rd][1] = #40 8;
            end
                4'b0011:
            begin
                out1 <= #60 rs1_data/rs2_data;
                count_md <= #60 1;
                tomasulo.pr3_mulexec <= #60 0;
                tomasulo.ROB[rob_ind][2] <= #60 out1;
                tomasulo.regbank[rd][1] <= #60 8;
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
    end
    $display("rs1_data = %b, rs2_data = %b, funct = %b, rob_ind = %b, exec_b = %b,out = %b",rs1_data,rs2_data,func,rob_ind,exec_b,out1);
    $display("Values of rob and regbank for r3 = %b and %b",tomasulo.ROB[0][2],tomasulo.regbank[3][1]);
end

endmodule
