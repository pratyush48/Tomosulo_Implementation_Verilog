module exec(out,rs1_data,rs2_data,func,rob_ind,clk1,rd);
reg []out;
input [7:0]rs1_data;
input [7:0]rs2_data;
input [3:0]func,rd;
input [2:0]rob_ind
input clk1;
always @(clk)
begin
    case(func)
        4'b0000: out = rs1_data+rs2_data
        4'b0001: out = rs1_data-rs2_data
        4'b0010: out = rs1_data*rs2_data
        4'b0011: out = rs1_data/rs2_data
        //4'b0100: out = tomasulo.memory[rs1_data+rs2_data];
        //4'b0101: out = rd
        //4'b0110: out = 
    tomasulo.ROB[rob_ind][2] = out;
    tomasulo.regbank[rd][1] = 8;
end
endmodule