module exec(out,rs1_data,rs2_data,func,rob_ind,clk1,rd);
output reg [7:0]out;
input [7:0]rs1_data;
input [7:0]rs2_data;
input [3:0]func,rd;
input [2:0]rob_ind;
input clk1;
integer count_as;
integer count_md;
wire out1;
always @(clk1)
begin
    count = 0;
    case(func)
        4'b0000:
        begin
            out1 <= #20 rs1_data+rs2_data;
            count_as <= 1;
        end
        4'b0001: 
        begin
            out1 <= #20 rs1_data+rs2_data;
            count_as <= 1;
        end
        4'b0010: 
        begin
            out1 <= #40 rs1_data+rs2_data;
            count_md <= 1;
        end
            4'b0011: 
        begin
            out1 <= #60 rs1_data+rs2_data;
            count_md <= 1;
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
    out <= out1;
    tomasulo.ROB[rob_ind][2] = out1;
    tomasulo.regbank[rd][1] = 8;
end
endmodule