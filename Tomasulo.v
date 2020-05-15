//
// module pipeline(out,rs1,rs2,rd,func,addr,clk1,clk2);
//
//       input [4:0] rs1,rs2,rd,func;
//       input [7:0] addr;
//       input clk1,clk2;
//       output [15:0] out;
//
//       reg [15:0]

module tomasulo;
reg[1:0] add_count,mul_count,bch_count;
reg[2:0] head_p,tail_p;
reg[2:0][3:0] add_array[0:4]; //RS add and sub
reg[1:0][3:0] mul_array[0:4]; //RS mul_array
reg[1:0][3:0] bch_array[0:4]; //RS branches
reg[15:0] regbank[0:15];
reg[7:0][2:0] ROB[0:15];
initial begin
  count = 2'b11;
end

endmodule
