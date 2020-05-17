module issue (rs1, rs2, rd, func,clk1, clk2);

input [3:0] rs1, rs2, rd, func;
wire [3:0] rs1_data,rs2_data;
input clk1, clk2;
output reg [15:0] Zout;
integer index;
// reg count;
// reg [2:0] tomasulo.pr2_rob_ind;
// reg rs1_b,rs2_b;
always @(posedge clk1)
begin
    index = rs1;
    tomasulo.pr2_count = 0;

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
            //Rstation_append rs(rs1_b,rs2_b,rs1,rs2,tomasulo.pr2_rob_ind,func,clk1,clk2,rd);
            //tomasulo.ROB[tomasulo.tail_p][0] <= func;
            //tomasulo.ROB[tomasulo.tail_p][1] <= rd;
            //tomasulo.tail_p <= tomasulo.tail_p + 1;
        end
        // else
            //stall
    end
    if (tomasulo.pr2_count == 1)
    begin
        tomasulo.ROB[tomasulo.tail_p][0] <= func;
        tomasulo.ROB[tomasulo.tail_p][1] <= rd;
        tomasulo.regbank[rd][1] <= tomasulo.tail_p;
        tomasulo.tail_p <= tomasulo.tail_p + 1;
        tomasulo.pr2_rob_ind = tomasulo.tail_p;
        if((func == 4'b0000) || (func == 4'b0001))
            tomasulo.add_count += 1;
        if((func == 4'b0010) || (func == 4'b0011))
            tomasulo.mul_count += 1;
    end
    begin
      tomasulo.pr2_rs1 <= rs1;
      tomasulo.pr2_rs2 <= rs2;
      tomasulo.pr2_func <= func;
      tomasulo.pr2_rd = rd;
    end
end

// always @(posedge clk1)
//   begin
//   #10
//   $display("add_count = %d \t mul_count = %d",tomasulo.add_count,tomasulo.mul_count);
//   $display("input to RS func %b\t%b\t%b\t%b\t%b",tomasulo.pr2_rs1b,tomasulo.pr2_rs2b,tomasulo.pr2_rs1,tomasulo.pr2_rs2,tomasulo.pr2_rob_ind);
//   $display("input to RS func %b\t%b\t%b\t%b\t%b",tomasulo.pr2_func,clk1,clk2,tomasulo.pr2_rd,tomasulo.pr2_count);
//   end


Rstation_append rs(tomasulo.pr2_rs1b,tomasulo.pr2_rs2b,tomasulo.pr2_rs1,tomasulo.pr2_rs2,tomasulo.pr2_rob_ind,tomasulo.pr2_func,clk1,clk2,tomasulo.pr2_rd,tomasulo.pr2_count);

endmodule
