module exec(out,rs1_data,rs2_data,func,rob_ind,clk1,rd);
reg []out;
input [7:0]rs1_data;
input [7:0]rs2_data;
input [3:0]func,rd;
input [2:0]rob_ind;
input clk1;
wire out1;
always @(clk1)
begin
    case(func)
        4'b0000: out1 = rs1_data+rs2_data;
        4'b0001: out1 = rs1_data-rs2_data;
        4'b0010: out1 = rs1_data*rs2_data;
        4'b0011: out1 = rs1_data/rs2_data;
        //4'b0100: out = tomasulo.memory[rs1_data+rs2_data];
        //4'b0101: out = rd
        //4'b0110: out = 
    out = out1;
    tomasulo.ROB[rob_ind][2] = out1;
    tomasulo.regbank[rd][1] = 8;
end
endmodule