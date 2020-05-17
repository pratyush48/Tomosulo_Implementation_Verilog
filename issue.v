module issue (rs1, rs2, rd, func,clk1, clk2);

input [3:0] rs1, rs2, rd, func;
wire [3:0] rs1_data,rs2_data;
input clk1, clk2;
output reg [15:0] Zout;
integer index;
reg count;
reg [2:0] rob_ind;
reg rs1_b,rs2_b;
always @(posedge clk1)
begin
    index = rs1;
    count = 0;
    if(tomasulo.regbank[index][1] < 16'b1000)
    begin
        rs1_b = 0;
        //rs1 = tomasulo.regbank[index][1];
    end
    else
        rs1_b = 1;
    if(tomasulo.regbank[rs2][1] < 16'b1000)
    begin
        rs2_b = 0;
        //rs2 = tomasulo.regbank[rs2][1];
    end
    else
        rs2_b = 1;
    if (tomasulo.tail_p - tomasulo.head_p == 7)
    begin
        if (tomasulo.tail_p == 7)
        begin
            if(tomasulo.add_count < 3)
                count =  1;
            else if(tomasulo.mul_count < 3)
                count = 1;
            else if(tomasulo.bch_count < 3)
                count = 1;
            // else
                //stall
        end
    end
    else if(tomasulo.tail_p - tomasulo.head_p < 7)
    begin
        if (tomasulo.tail_p == 7)
        begin
            if(tomasulo.add_count < 3)
                count = 1;
            else if(tomasulo.mul_count < 3)
                count = 1;
            else if(tomasulo.bch_count < 3)
                count = 1;
            // else
                //stall
        end
        else
        begin
            if(tomasulo.add_count < 3)
                count = 1;
            else if(tomasulo.mul_count < 3)
                count = 1;
            else if(tomasulo.bch_count < 3)
                count = 1;
            // else
                //stall
        end
    end
    else
    begin
        if(tomasulo.add_count < 3)
            count = 1;
        else if(tomasulo.mul_count < 3)
            count = 1;
        else if(tomasulo.bch_count < 3)
        begin
            count = 1;
            //Rstation_append rs(rs1_b,rs2_b,rs1,rs2,rob_ind,func,clk1,clk2,rd);
            //tomasulo.ROB[tomasulo.tail_p][0] <= func;
            //tomasulo.ROB[tomasulo.tail_p][1] <= rd;
            //tomasulo.tail_p <= tomasulo.tail_p + 1;
        end
        // else
            //stall
    end
    if (count == 1)
    begin
        tomasulo.ROB[tomasulo.tail_p][0] <= func;
        tomasulo.ROB[tomasulo.tail_p][1] <= rd;
        tomasulo.tail_p <= tomasulo.tail_p + 1;
        rob_ind = tomasulo.tail_p;
    end
end
Rstation_append rs(rs1_b,rs2_b,rs1,rs2,rob_ind,func,clk1,clk2,rd,count);
endmodule
