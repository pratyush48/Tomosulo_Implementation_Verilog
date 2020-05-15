//
// module pipeline(out,rs1,rs2,rd,func,addr,clk1,clk2);
//
//       input [4:0] rs1,rs2,rd,func;
//       input [7:0] addr;
//       input clk1,clk2;
//       output [15:0] out;
//
//       reg [15:0]


//Instructions that are defined

// add = 0000
// sub = 0001
// mul = 0010
// div = 0011
// load = 0100
// store = 0101
// beq = 0110
// bneq = 0111

module tomasulo;
reg[1:0] add_count,mul_count,bch_count;
reg[2:0] head_p,tail_p;
reg[4:0] add_array[0:2][0:5]; //RS add and sub
reg[4:0] mul_array[0:2][0:5]; //RS mul_array
reg[4:0] bch_array[0:1][0:5]; //RS branches
reg[15:0] ls_queue[0:3][0:2]; //Each index should be 16 bits since we wil be storing the data
reg[15:0] regbank[0:15];
reg[15:0] ROB[0:7][0:2];  //Each index should be 16 bits since we wil be storing the data
initial begin
  add_array[2][3] = 2'b00;
  add_count = 2'b00;
  $display("value: %b",add_array[2][3]);
end

endmodule
