module issue (Zout, rs1, rs2, rd, func, addr, clk1, clk2);

input [3:0] rs1, rs2, rd, func;
input [7:0] addr;
input write, clk1, clk2;
output [15:0] Zout;

reg [15:0] L12_A, L12_B, L12_Z, L34_Z;
reg [3:0] L12_rd, L12_func, L23_rd;
reg [7:0] L12_addr, L23_addr, L34_addr;

reg [15:0] regbank [0:15];
reg [15:0] mem[0:255];
always @(tomosulo.tail_p or tomosulo.head_p)
begin  
    if (tomosulo.tail_p - tomosulo.head_p == 0)
        if (tomosulo.tail_p == 7)
            if(tomosulo.add_count < 3)
                //call rs
                tomosulo.tail_p = 0;
            else if(tomosulo.mul_count < 3)
                //call rs
                tomosulo.tail_p = 0;
            else if(tomosulo.bch_count < 3)
                //call rs
                tomosulo.tail_p = 0;
            else
                //stall
        else 
            if (tomosulo.tail_p == 7)
                if(tomosulo.add_count < 3)
                    //call rs
                    tomosulo.tail_p += 1;
                else if(tomosulo.mul_count < 3)
                    //call rs
                    tomosulo.tail_p += 1;
                else if(tomosulo.bch_count < 3)
                    //call rs
                    tomosulo.tail_p += 1;
                else
                    //stall        
    else if(tomosulo.tail_p - tomosulo.head_p < 7)
        if (tomosulo.tail_p == 7)
            if(tomosulo.add_count < 3)
                //call rs
                tomosulo.tail_p = 0;
            else if(tomosulo.mul_count < 3)
                //call rs
                tomosulo.tail_p = 0;
            else if(tomosulo.bch_count < 3)
                //call rs
                tomosulo.tail_p = 0;
            else
                //stall
        else 
            if (tomosulo.tail_p == 7)
                if(tomosulo.add_count < 3)
                    //call rs
                    tomosulo.tail_p += 1;
                else if(tomosulo.mul_count < 3)
                    //call rs
                    tomosulo.tail_p += 1;
                else if(tomosulo.bch_count < 3)
                    //call rs
                    tomosulo.tail_p += 1;
                else
                    //stall       
    else
        if (tomosulo.tail_p == 7)
            if(tomosulo.add_count < 3)
                //call rs
                tomosulo.tail_p += 1;
            else if(tomosulo.mul_count < 3)
                //call rs
                tomosulo.tail_p += 1;
            else if(tomosulo.bch_count < 3)
                //call rs
                tomosulo.tail_p += 1;
            else
                //stall  
end
assign Zout = L34_Z;

