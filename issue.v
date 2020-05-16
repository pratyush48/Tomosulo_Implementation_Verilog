module issue (Zout, rs1, rs2, rd, func, addr, clk1, clk2);

input [3:0] rs1, rs2, rd, func;
input [7:0] addr;
input write, clk1, clk2;
output [15:0] Zout;

reg [15:0] L12_A, L12_B, L12_Z, L34_Z;
reg [3:0] L12_rd, L12_func, L23_rd;
reg [7:0] L12_addr, L23_addr, L34_addr;

wire rs1_b,rs2_b;
always @(posedge clk1)
begin
    if(tomasulo.regbank[rs1][1] < 8)
    begin
        rs1_b = 0;
        rs1 = tomasulo.regbank[rs1][1];
    end
    else
        rs1_b = 1;
    if(tomasulo.regbank[rs2][1] < 8)
    begin
        rs2_b = 0;
        rs2 = tomasulo.regbank[rs2][1];
    end
    else
        rs2_b = 1;
    if (tomasulo.tail_p - tomasulo.head_p == 7)
    begin
        if (tomasulo.tail_p == 7)
        begin
            if(tomasulo.add_count < 3)
            begin
                //call rs
                tomasulo.ROB[tomasulo.tail_p][0] <= func;
                tomasulo.ROB[tomasulo.tail_p][1] <= rd;
                tomasulo.regbank[rd][1] <= tomasulo.tail_p;
                tomasulo.tail_p <= 0;
            end
            else if(tomasulo.mul_count < 3)
            begin
                //call rs
                tomasulo.ROB[tomasulo.tail_p][0] <= func;
                tomasulo.ROB[tomasulo.tail_p][1] <= rd;
                tomasulo.regbank[rd][1] <= tomasulo.tail_p;
                tomasulo.tail_p <= 0;
            end
            else if(tomasulo.bch_count < 3)
            begin
                //call rs
                tomasulo.ROB[tomasulo.tail_p][0] <= func;
                tomasulo.ROB[tomasulo.tail_p][1] <= rd;
                tomasulo.regbank[rd][1] <= tomasulo.tail_p;
                tomasulo.tail_p <= 0;
            end
            else
                //stall
        end
    end
    else if(tomasulo.tail_p - tomasulo.head_p < 7)
    begin
        if (tomasulo.tail_p == 7)
        begin
            if(tomasulo.add_count < 3)
            begin
                //call rs
                tomasulo.ROB[tomasulo.tail_p][0] <= func;
                tomasulo.ROB[tomasulo.tail_p][1] <= rd;
                tomasulo.regbank[rd][1] <= tomasulo.tail_p;
                tomasulo.tail_p <= 0;
            end
            else if(tomasulo.mul_count < 3)
            begin
                //call rs
                tomasulo.ROB[tomasulo.tail_p][0] <= func;
                tomasulo.ROB[tomasulo.tail_p][1] <= rd;
                tomasulo.regbank[rd][1] <= tomasulo.tail_p;
                tomasulo.tail_p <= 0;
            end
            else if(tomasulo.bch_count < 3)
            begin
                //call rs
                tomasulo.ROB[tomasulo.tail_p][0] <= func;
                tomasulo.ROB[tomasulo.tail_p][1] <= rd;
                tomasulo.regbank[rd][1] <= tomasulo.tail_p;
                tomasulo.tail_p <= 0;
            end
            else
                //stall
        end
        else
        begin
            if(tomasulo.add_count < 3)
            begin
                //call rs
                tomasulo.ROB[tomasulo.tail_p][0] <= func;
                tomasulo.ROB[tomasulo.tail_p][1] <= rd;
                tomasulo.regbank[rd][1] <= tomasulo.tail_p;
                tomasulo.tail_p <= tomasulo.tail_p + 1;
            end
            else if(tomasulo.mul_count < 3)
            begin
                //call rs
                tomasulo.ROB[tomasulo.tail_p][0] <= func;
                tomasulo.ROB[tomasulo.tail_p][1] <= rd;
                tomasulo.regbank[rd][1] <= tomasulo.tail_p;
                tomasulo.tail_p <= tomasulo.tail_p + 1;
            end
            else if(tomasulo.bch_count < 3)
            begin
                //call rs
                tomasulo.ROB[tomasulo.tail_p][0] <= func;
                tomasulo.ROB[tomasulo.tail_p][1] <= rd;
                tomasulo.regbank[rd][1] <= tomasulo.tail_p;
                tomasulo.tail_p <= tomasulo.tail_p + 1;
            end
            else
                //stall
        end
    end
    else
    begin
        if(tomasulo.add_count < 3)
        begin
            //call rs
                tomasulo.ROB[tomasulo.tail_p][0] <= func;
                tomasulo.ROB[tomasulo.tail_p][1] <= rd;
                tomasulo.tail_p <= tomasulo.tail_p + 1;
        end
        else if(tomasulo.mul_count < 3)
        begin
            //call rs
                tomasulo.ROB[tomasulo.tail_p][0] <= func;
                tomasulo.ROB[tomasulo.tail_p][1] <= rd;
                tomasulo.tail_p <= tomasulo.tail_p + 1;
        end
        else if(tomasulo.bch_count < 3)
        begin
            //call rs
                tomasulo.ROB[tomasulo.tail_p][0] <= func;
                tomasulo.ROB[tomasulo.tail_p][1] <= rd;
                tomasulo.tail_p <= tomasulo.tail_p + 1;
        end
        else
            //stall
    end
end
assign Zout = L34_Z;
