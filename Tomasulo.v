module tomasulo(pc,clk1,clk2);

  input[3:0] pc;
  input clk1,clk2;

  wire [15:0] inst; //This is for getting instruction from ins set
  reg [3:0] rs1,rs2,func,rd;
  reg [1:0] add_count,mul_count,bch_count;
  reg [2:0] head_p,tail_p;
  reg [3:0] add_array[0:2][0:5]; //RS add and sub
  reg [3:0] mul_array[0:2][0:5]; //RS mul_array
  reg [4:0] bch_array[0:1][0:2]; //RS branches
  reg [15:0] ls_queue[0:3][0:2]; //Each index should be 16 bits since we wil be storing the data
  reg [15:0] regbank[0:15]; //First column is actual value and second column is ROB
  reg [15:0] ROB[0:7][0:2];  //Each index should be 16 bits since we will be storing the data
  reg [15:0] memory[0:255]; //Memory


instruction_set k1(pc,clk1,inst);

always @(pc)
  begin
  #10;
  func = inst[15:12];
  rs1 = inst[11:8];
  rs2 = inst[7:4];
  rd = inst[3:0];
  $display("values of pc = %b",pc);
  $display("values of func = %b",func);
  $display("values of rs1 = %b",rs1);
  $display("values of rs2 = %b",rs2);
  $display("values of rd = %b",rd);
end

endmodule

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
//Ins format = func,rs1,rs2,rd
//for branches, imm[3:0] = rd
//for ld,store, func,main_addr,rd
