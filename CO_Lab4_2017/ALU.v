module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//I/O ports 
input	[32-1:0] aluSrc1;
input	[32-1:0] aluSrc2;
input	 [4-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 overflow;

//Internal Signals
wire			 zero;
wire			 overflow;
wire	[32-1:0] result;

//Main function
/*your code here*/

  wire[31:0] overf;
  wire set;
  wire carryIn;
  wire invertA;
  wire invertB;
  wire [1:0] operation;
  wire [32-1:0] result_cal;

  assign invertA = ALU_operation_i[3];

  assign invertB = ALU_operation_i[2];

  assign operation = ALU_operation_i[1:0];

  assign carryIn = (ALU_operation_i[3:2] == 2'b01)? 1 : 0;

  assign overflow = overf[30] ^ overf[31];

  assign zero = (result == 0)? 1 : 0;  

  assign result = (ALU_operation_i == 4'b1111)? 0 : result_cal; //如果是don't card or jr 就把result設定成0

  ALU_1bit ALU1(result_cal[0], overf[0], aluSrc1[0], aluSrc2[0], invertA, invertB, operation, carryIn, set);
  ALU_1bit ALU2(result_cal[1], overf[1], aluSrc1[1], aluSrc2[1], invertA, invertB, operation, overf[0], 1'b0);
  ALU_1bit ALU3(result_cal[2], overf[2], aluSrc1[2], aluSrc2[2], invertA, invertB, operation, overf[1], 1'b0);
  ALU_1bit ALU4(result_cal[3], overf[3], aluSrc1[3], aluSrc2[3], invertA, invertB, operation, overf[2], 1'b0);
  ALU_1bit ALU5(result_cal[4], overf[4], aluSrc1[4], aluSrc2[4], invertA, invertB, operation, overf[3], 1'b0);
  ALU_1bit ALU6(result_cal[5], overf[5], aluSrc1[5], aluSrc2[5], invertA, invertB, operation, overf[4], 1'b0);
  ALU_1bit ALU7(result_cal[6], overf[6], aluSrc1[6], aluSrc2[6], invertA, invertB, operation, overf[5], 1'b0);
  ALU_1bit ALU8(result_cal[7], overf[7], aluSrc1[7], aluSrc2[7], invertA, invertB, operation, overf[6], 1'b0);
  ALU_1bit ALU9(result_cal[8], overf[8], aluSrc1[8], aluSrc2[8], invertA, invertB, operation, overf[7], 1'b0);
  ALU_1bit ALU10(result_cal[9], overf[9], aluSrc1[9], aluSrc2[9], invertA, invertB, operation, overf[8], 1'b0);
  ALU_1bit ALU11(result_cal[10], overf[10], aluSrc1[10], aluSrc2[10], invertA, invertB, operation, overf[9], 1'b0);
  ALU_1bit ALU12(result_cal[11], overf[11], aluSrc1[11], aluSrc2[11], invertA, invertB, operation, overf[10], 1'b0);
  ALU_1bit ALU13(result_cal[12], overf[12], aluSrc1[12], aluSrc2[12], invertA, invertB, operation, overf[11], 1'b0);
  ALU_1bit ALU14(result_cal[13], overf[13], aluSrc1[13], aluSrc2[13], invertA, invertB, operation, overf[12], 1'b0);
  ALU_1bit ALU15(result_cal[14], overf[14], aluSrc1[14], aluSrc2[14], invertA, invertB, operation, overf[13], 1'b0);
  ALU_1bit ALU16(result_cal[15], overf[15], aluSrc1[15], aluSrc2[15], invertA, invertB, operation, overf[14], 1'b0);
  ALU_1bit ALU17(result_cal[16], overf[16], aluSrc1[16], aluSrc2[16], invertA, invertB, operation, overf[15], 1'b0);
  ALU_1bit ALU18(result_cal[17], overf[17], aluSrc1[17], aluSrc2[17], invertA, invertB, operation, overf[16], 1'b0);
  ALU_1bit ALU19(result_cal[18], overf[18], aluSrc1[18], aluSrc2[18], invertA, invertB, operation, overf[17], 1'b0);
  ALU_1bit ALU20(result_cal[19], overf[19], aluSrc1[19], aluSrc2[19], invertA, invertB, operation, overf[18], 1'b0);
  ALU_1bit ALU21(result_cal[20], overf[20], aluSrc1[20], aluSrc2[20], invertA, invertB, operation, overf[19], 1'b0);
  ALU_1bit ALU22(result_cal[21], overf[21], aluSrc1[21], aluSrc2[21], invertA, invertB, operation, overf[20], 1'b0);
  ALU_1bit ALU23(result_cal[22], overf[22], aluSrc1[22], aluSrc2[22], invertA, invertB, operation, overf[21], 1'b0);
  ALU_1bit ALU24(result_cal[23], overf[23], aluSrc1[23], aluSrc2[23], invertA, invertB, operation, overf[22], 1'b0);
  ALU_1bit ALU25(result_cal[24], overf[24], aluSrc1[24], aluSrc2[24], invertA, invertB, operation, overf[23], 1'b0);
  ALU_1bit ALU26(result_cal[25], overf[25], aluSrc1[25], aluSrc2[25], invertA, invertB, operation, overf[24], 1'b0);
  ALU_1bit ALU27(result_cal[26], overf[26], aluSrc1[26], aluSrc2[26], invertA, invertB, operation, overf[25], 1'b0);
  ALU_1bit ALU28(result_cal[27], overf[27], aluSrc1[27], aluSrc2[27], invertA, invertB, operation, overf[26], 1'b0);
  ALU_1bit ALU29(result_cal[28], overf[28], aluSrc1[28], aluSrc2[28], invertA, invertB, operation, overf[27], 1'b0);
  ALU_1bit ALU30(result_cal[29], overf[29], aluSrc1[29], aluSrc2[29], invertA, invertB, operation, overf[28], 1'b0);
  ALU_1bit ALU31(result_cal[30], overf[30], aluSrc1[30], aluSrc2[30], invertA, invertB, operation, overf[29], 1'b0);
  ALU_1bit_32 ALU32(result_cal[31], overf[31], aluSrc1[31], aluSrc2[31], invertA, invertB, operation, overf[30], 1'b0, set);



endmodule




module ALU_1bit( result, carryOut, a, b, invertA, invertB, operation, carryIn, less ); 
  
  output wire result;
  output wire carryOut;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  /*your code here*/ 

  wire add_result, add_carryOut;
  wire in_a;
  wire in_b;
  assign in_a = invertA? ~a: a; 
  assign in_b = invertB? ~b: b;
  
  Full_adder FA(add_result, add_carryOut, carryIn, in_a, in_b);

  assign result = (operation == 2'b00) ?  in_a & in_b:
                  (operation == 2'b01) ?  in_a | in_b :
                  (operation == 2'b10) ?  add_result:
                                          less;

  assign carryOut = (operation == 2'b00) ?  0 :
                    (operation == 2'b01) ?  0 :
                    (operation == 2'b10) ?  add_carryOut:
                                            add_carryOut;               
endmodule

module ALU_1bit_32( result, carryOut, a, b, invertA, invertB, operation, carryIn, less, set); 
  
  output wire result;
  output wire carryOut;
  output wire set;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  /*your code here*/ 

  wire add_result, add_carryOut;
  wire in_a;
  wire in_b;
  assign in_a = invertA? ~a: a; 
  assign in_b = invertB? ~b: b;
  
  Full_adder FA(add_result, add_carryOut, carryIn, in_a, in_b);

  assign result = (operation == 2'b00) ?  in_a & in_b:
                  (operation == 2'b01) ?  in_a | in_b :
                  (operation == 2'b10) ?  add_result:
                                          less;

  assign carryOut = (operation == 2'b00) ?  0 :
                    (operation == 2'b01) ?  0 :
                    (operation == 2'b10) ?  add_carryOut:
                                            add_carryOut;  

  assign set = (operation == 2'b11)? add_result:
                                     0;

endmodule


module Full_adder(sum, carryOut, carryIn, input1, input2);

	input carryIn, input1, input2;

	output sum, carryOut;

	wire w1, w2, w3;

	xor x1(w1, input1, input2);
	xor x2(sum, w1, carryIn);
	and a1(w2, input1, input2);
	and a2(w3, w1, carryIn);
	or o1(carryOut, w2, w3);

endmodule