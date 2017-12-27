module ALU( result, zero, overflow, aluSrc1, aluSrc2, invertA, invertB, operation );
   
  output wire[31:0] result;
  output wire zero;
  output wire overflow;

  input wire[31:0] aluSrc1;
  input wire[31:0] aluSrc2;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  
  /*your code here*/
  wire[31:0] overf;
  wire set;
  wire carryIn;

  assign carryIn = (operation == 2'b10 && invertB == 1'b1)? 1 : 0;

  assign overflow = overf[30] ^ overf[31];

  assign zero = (result == 0)? 1 : 0;  

  ALU_1bit ALU1(result[0], overf[0], aluSrc1[0], aluSrc2[0], invertA, invertB, operation, carryIn, set);
  ALU_1bit ALU2(result[1], overf[1], aluSrc1[1], aluSrc2[1], invertA, invertB, operation, overf[0], 1'b0);
  ALU_1bit ALU3(result[2], overf[2], aluSrc1[2], aluSrc2[2], invertA, invertB, operation, overf[1], 1'b0);
  ALU_1bit ALU4(result[3], overf[3], aluSrc1[3], aluSrc2[3], invertA, invertB, operation, overf[2], 1'b0);
  ALU_1bit ALU5(result[4], overf[4], aluSrc1[4], aluSrc2[4], invertA, invertB, operation, overf[3], 1'b0);
  ALU_1bit ALU6(result[5], overf[5], aluSrc1[5], aluSrc2[5], invertA, invertB, operation, overf[4], 1'b0);
  ALU_1bit ALU7(result[6], overf[6], aluSrc1[6], aluSrc2[6], invertA, invertB, operation, overf[5], 1'b0);
  ALU_1bit ALU8(result[7], overf[7], aluSrc1[7], aluSrc2[7], invertA, invertB, operation, overf[6], 1'b0);
  ALU_1bit ALU9(result[8], overf[8], aluSrc1[8], aluSrc2[8], invertA, invertB, operation, overf[7], 1'b0);
  ALU_1bit ALU10(result[9], overf[9], aluSrc1[9], aluSrc2[9], invertA, invertB, operation, overf[8], 1'b0);
  ALU_1bit ALU11(result[10], overf[10], aluSrc1[10], aluSrc2[10], invertA, invertB, operation, overf[9], 1'b0);
  ALU_1bit ALU12(result[11], overf[11], aluSrc1[11], aluSrc2[11], invertA, invertB, operation, overf[10], 1'b0);
  ALU_1bit ALU13(result[12], overf[12], aluSrc1[12], aluSrc2[12], invertA, invertB, operation, overf[11], 1'b0);
  ALU_1bit ALU14(result[13], overf[13], aluSrc1[13], aluSrc2[13], invertA, invertB, operation, overf[12], 1'b0);
  ALU_1bit ALU15(result[14], overf[14], aluSrc1[14], aluSrc2[14], invertA, invertB, operation, overf[13], 1'b0);
  ALU_1bit ALU16(result[15], overf[15], aluSrc1[15], aluSrc2[15], invertA, invertB, operation, overf[14], 1'b0);
  ALU_1bit ALU17(result[16], overf[16], aluSrc1[16], aluSrc2[16], invertA, invertB, operation, overf[15], 1'b0);
  ALU_1bit ALU18(result[17], overf[17], aluSrc1[17], aluSrc2[17], invertA, invertB, operation, overf[16], 1'b0);
  ALU_1bit ALU19(result[18], overf[18], aluSrc1[18], aluSrc2[18], invertA, invertB, operation, overf[17], 1'b0);
  ALU_1bit ALU20(result[19], overf[19], aluSrc1[19], aluSrc2[19], invertA, invertB, operation, overf[18], 1'b0);
  ALU_1bit ALU21(result[20], overf[20], aluSrc1[20], aluSrc2[20], invertA, invertB, operation, overf[19], 1'b0);
  ALU_1bit ALU22(result[21], overf[21], aluSrc1[21], aluSrc2[21], invertA, invertB, operation, overf[20], 1'b0);
  ALU_1bit ALU23(result[22], overf[22], aluSrc1[22], aluSrc2[22], invertA, invertB, operation, overf[21], 1'b0);
  ALU_1bit ALU24(result[23], overf[23], aluSrc1[23], aluSrc2[23], invertA, invertB, operation, overf[22], 1'b0);
  ALU_1bit ALU25(result[24], overf[24], aluSrc1[24], aluSrc2[24], invertA, invertB, operation, overf[23], 1'b0);
  ALU_1bit ALU26(result[25], overf[25], aluSrc1[25], aluSrc2[25], invertA, invertB, operation, overf[24], 1'b0);
  ALU_1bit ALU27(result[26], overf[26], aluSrc1[26], aluSrc2[26], invertA, invertB, operation, overf[25], 1'b0);
  ALU_1bit ALU28(result[27], overf[27], aluSrc1[27], aluSrc2[27], invertA, invertB, operation, overf[26], 1'b0);
  ALU_1bit ALU29(result[28], overf[28], aluSrc1[28], aluSrc2[28], invertA, invertB, operation, overf[27], 1'b0);
  ALU_1bit ALU30(result[29], overf[29], aluSrc1[29], aluSrc2[29], invertA, invertB, operation, overf[28], 1'b0);
  ALU_1bit ALU31(result[30], overf[30], aluSrc1[30], aluSrc2[30], invertA, invertB, operation, overf[29], 1'b0);
  ALU_1bit_32 ALU32(result[31], overf[31], aluSrc1[31], aluSrc2[31], invertA, invertB, operation, overf[30], 1'b0, set);


       


	  
endmodule