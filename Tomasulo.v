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
//for ld,store, func,rs1+ s2 - base address,rd


module tomasulo(pc,clk1,clk2);

  input[3:0] pc;
  input clk1,clk2;

  wire [15:0] inst; //This is for getting instruction from ins set
  // reg [3:0] rs1,rs2,func,rd;

  //These are stage 1 pr
  reg [3:0] pr1_rs1,pr1_rs2,pr1_func,pr1_rd;
  reg pr2_count;
  //These are stage 2 pr
  reg [3:0] pr2_rs1,pr2_rs2,pr2_func,pr2_rd;
  reg[2:0] pr2_rob_ind;
  //Stall bit
  reg stall_bit;

  //These are stage3 that is RS stage
  //1st bit and 2nd bit are for add-sub exec unit
  //3rd and 4th are for mul-div exec unit
  reg [3:0] pr3_exec_b;
  reg [7:0] pr3_rs1data[0:3],pr3_rs2data[0:3];
  reg [3:0] pr3_func[0:3],pr3_rd[0:3];
  reg [2:0] pr3_rob_ind[0:3],pr3_rsindex[0:3];
  integer pr3_addcount,pr3_mulcount;

  //This is for issue stage
  integer add_count,mul_count,bch_count; //These are needed in issue stage
  reg [2:0] head_p,tail_p;
  //RS coulmns: func,rs1,rs2,rob,rs1b,rs2b,busy,exec_busy
  reg [3:0] add_array[0:2][0:7]; //RS add and sub
  reg [3:0] mul_array[0:2][0:7]; //RS mul_array
  reg [4:0] bch_array[0:1][0:7]; //RS branches
  reg [15:0] ls_queue[0:3][0:7]; //Each index should be 16 bits since we wil be storing the data
  reg [15:0] regbank[0:15][0:1]; //First column is actual value and second column is ROB
  reg [15:0] ROB[0:7][0:2];  //Each index should be 16 bits since we will be storing the data
  reg [15:0] memory[0:255]; //Memory


instruction_set k1(pc,clk1,inst);

always @(posedge clk2)
  begin
    if(tomasulo.stall_bit == 0)
    begin
      $display("In fetch stage:");
      pr1_func = inst[15:12];
      pr1_rs1 = inst[11:8];
      pr1_rs2 = inst[7:4];
      pr1_rd = inst[3:0];
      $display("values of pc = %b,values of func = %b,values of rs1 = %b,values of rs2 = %b,values of rd = %b",pc,pr1_func,pr1_rs1,pr1_rs2,pr1_rd);
    end
end

issue is1(pr1_rs1, pr1_rs2, pr1_rd, pr1_func,clk1, clk2);

endmodule
