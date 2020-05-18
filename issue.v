module issue (rs1, rs2, rd, func,clk1, clk2);

input [3:0] rs1, rs2, rd, func;
wire [3:0] rs1_data,rs2_data;
input clk1, clk2;
output reg [15:0] Zout;
// reg count;
// reg [2:0] tomasulo.pr2_rob_ind;
// reg rs1_b,rs2_b;
always @(posedge clk2)
begin
    tomasulo.pr2_count = 0;
    $display("Issue stage : ");
    $display("rs1 = %b,rs2 = %b,func = %b",rs1,rs2,func);
    if(tomasulo.regbank[rs1][1] < 16'b1000)
        tomasulo.pr2_rs1b = 0;
    else
        tomasulo.pr2_rs1b = 1;
    if(tomasulo.regbank[rs2][1] < 16'b1000)
        tomasulo.pr2_rs2b = 0;
    else
        tomasulo.pr2_rs2b = 1;

    if (tomasulo.tail_p - tomasulo.head_p == 7)
    begin
        if (tomasulo.tail_p == 7)
        begin
            if(tomasulo.add_count < 3)
                tomasulo.pr2_count   =  1;
            else if(tomasulo.mul_count < 3)
                tomasulo.pr2_count = 1;
            else if(tomasulo.bch_count < 3)
                tomasulo.pr2_count = 1;
            // else
                //stall
        end
    end
    else if(tomasulo.tail_p - tomasulo.head_p < 7)
    begin
        if (tomasulo.tail_p == 7)
        begin
            if(tomasulo.add_count < 3)
                tomasulo.pr2_count = 1;
            else if(tomasulo.mul_count < 3)
                tomasulo.pr2_count = 1;
            else if(tomasulo.bch_count < 3)
                tomasulo.pr2_count = 1;
            // else
                //stall
        end
        else
        begin
            if(tomasulo.add_count < 3)
                tomasulo.pr2_count = 1;
            else if(tomasulo.mul_count < 3)
                tomasulo.pr2_count = 1;
            else if(tomasulo.bch_count < 3)
                tomasulo.pr2_count = 1;
            // else
                //stall
        end
    end
    else
    begin
        if(tomasulo.add_count < 3)
            tomasulo.pr2_count = 1;
        else if(tomasulo.mul_count < 3)
            tomasulo.pr2_count = 1;
        else if(tomasulo.bch_count < 3)
        begin
            tomasulo.pr2_count = 1;
        end
        // else
            //stall
    end

    if (tomasulo.pr2_count == 1)
    begin
    $display("rs1_b = %b,rs2_b = %b,func = %b",tomasulo.pr2_rs1b,tomasulo.pr2_rs2b,func);
        tomasulo.ROB[tomasulo.tail_p][0] = func;
        tomasulo.ROB[tomasulo.tail_p][1] = rd;
        tomasulo.regbank[rd][1] = tomasulo.tail_p;
        tomasulo.pr2_rob_ind = tomasulo.tail_p;
        tomasulo.tail_p = tomasulo.tail_p + 1;
        if((func == 4'b0000) || (func == 4'b0001))
            tomasulo.add_count += 1;
        if((func == 4'b0010) || (func == 4'b0011))
            tomasulo.mul_count += 1;
    end
    if(tomasulo.pr2_rs1b == 0)
      tomasulo.pr2_rs1 = tomasulo.regbank[rs1][1];
    else
      tomasulo.pr2_rs1 = rs1;
    if(tomasulo.pr2_rs2b == 0)
      tomasulo.pr2_rs2 = tomasulo.regbank[rs2][1];
    else
      tomasulo.pr2_rs2 = rs2   ;
    tomasulo.pr2_func = func;
    tomasulo.pr2_rd = rd;

    $display("rs1b,rs2b,rs1,rs2,rob_ind,func,clk1,clk2,rd,count");
    $display("%b\t%b\t%b\t%b\t%b",tomasulo.pr2_rs1b,tomasulo.pr2_rs2b,tomasulo.pr2_rs1,tomasulo.pr2_rs2,tomasulo.pr2_rob_ind);
    $display("%b\t%b\t%b\t%b\t%b",tomasulo.pr2_func,clk1,clk2,tomasulo.pr2_rd,tomasulo.pr2_count);
end

Rstation_append rs(tomasulo.pr2_rs1b,tomasulo.pr2_rs2b,tomasulo.pr2_rs1,tomasulo.pr2_rs2,tomasulo.pr2_rob_ind,tomasulo.pr2_func,clk1,clk2,tomasulo.pr2_rd,tomasulo.pr2_count);

endmodule
