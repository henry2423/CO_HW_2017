//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:0416315�����416005張彧��
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module ALU(
	rst,
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);

//I/O ports
input rst;
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
reg             zero_o;

//Parameter
wire equal_in;
/*wire [32-1:0] temp_equal_out; //For the output port of 1-bit ALU
wire [32-1:0] temp_result;    //For the output port of 1-bit ALU
*/
wire [33-1:0] temp_cout;
wire [33-1:0] temp_equal_out; //For the output port of 1-bit ALU
wire [33-1:0] temp_result;    //For the output port of 1-bit ALU
wire set_out;                 //For the set output port of 1-bit ALUq
wire src1_extraMSB;
wire src2_extraMSB;
wire A_invert;
wire [32-1:0] SLL_result;
wire [32-1:0] LUI_result;
wire [32-1:0] MUL_result;

assign src1_extraMSB = (ctrl_i==4'b1111) ? 1'b0 : src1_i[31];
assign src2_extraMSB = (ctrl_i==4'b1111) ? 1'b0 : src2_i[31];
assign A_invert = (ctrl_i==4'b1111 || ctrl_i==4'b1110) ? 1'b0 : ctrl_i[3];

assign equal_in = (&temp_equal_out);
assign SLL_result = src2_i << src1_i[4:0];
assign LUI_result = {src2_i[15:0],16'b0};//src2_i << 5'd16;
assign MUL_result = src1_i*src2_i;

alu_top  alu00(
	.src1(src1_i[0]),.src2(src2_i[0]),.less(set_out),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(ctrl_i[2]&ctrl_i[1]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[0]),
	.result(temp_result[0]),
	.cout(temp_cout[0])
	);
alu_top  alu01(
	.src1(src1_i[1]),.src2(src2_i[1]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[0]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[1]),
	.result(temp_result[1]),
	.cout(temp_cout[1])
	);
alu_top  alu02(
	.src1(src1_i[2]),.src2(src2_i[2]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[1]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[2]),
	.result(temp_result[2]),
	.cout(temp_cout[2])
	);
alu_top  alu03(
	.src1(src1_i[3]),.src2(src2_i[3]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[2]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[3]),
	.result(temp_result[3]),
	.cout(temp_cout[3])
	);
alu_top  alu04(
	.src1(src1_i[4]),.src2(src2_i[4]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[3]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[4]),
	.result(temp_result[4]),
	.cout(temp_cout[4])
	);
alu_top  alu05(
	.src1(src1_i[5]),.src2(src2_i[5]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[4]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[5]),
	.result(temp_result[5]),
	.cout(temp_cout[5])
	);
alu_top  alu06(
	.src1(src1_i[6]),.src2(src2_i[6]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[5]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[6]),
	.result(temp_result[6]),
	.cout(temp_cout[6])
	);
alu_top  alu07(
	.src1(src1_i[7]),.src2(src2_i[7]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[6]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[7]),
	.result(temp_result[7]),
	.cout(temp_cout[7])
	);
alu_top  alu08(
	.src1(src1_i[8]),.src2(src2_i[8]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[7]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[8]),
	.result(temp_result[8]),
	.cout(temp_cout[8])
	);
alu_top  alu09(
	.src1(src1_i[9]),.src2(src2_i[9]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[8]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[9]),
	.result(temp_result[9]),
	.cout(temp_cout[9])
	);
alu_top  alu10(
	.src1(src1_i[10]),.src2(src2_i[10]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[9]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[10]),
	.result(temp_result[10]),
	.cout(temp_cout[10])
	);
alu_top  alu11(
	.src1(src1_i[11]),.src2(src2_i[11]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[10]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[11]),
	.result(temp_result[11]),
	.cout(temp_cout[11])
	);
alu_top  alu12(
	.src1(src1_i[12]),.src2(src2_i[12]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[11]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[12]),
	.result(temp_result[12]),
	.cout(temp_cout[12])
	);
alu_top  alu13(
	.src1(src1_i[13]),.src2(src2_i[13]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[12]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[13]),
	.result(temp_result[13]),
	.cout(temp_cout[13])
	);
alu_top  alu14(
	.src1(src1_i[14]),.src2(src2_i[14]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[13]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[14]),
	.result(temp_result[14]),
	.cout(temp_cout[14])
	);
alu_top  alu15(
	.src1(src1_i[15]),.src2(src2_i[15]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[14]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[15]),
	.result(temp_result[15]),
	.cout(temp_cout[15])
	);
alu_top  alu16(
	.src1(src1_i[16]),.src2(src2_i[16]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[15]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[16]),
	.result(temp_result[16]),
	.cout(temp_cout[16])
	);
alu_top  alu17(
	.src1(src1_i[17]),.src2(src2_i[17]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[16]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[17]),
	.result(temp_result[17]),
	.cout(temp_cout[17])
	);
alu_top  alu18(
	.src1(src1_i[18]),.src2(src2_i[18]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[17]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[18]),
	.result(temp_result[18]),
	.cout(temp_cout[18])
	);
alu_top  alu19(
	.src1(src1_i[19]),.src2(src2_i[19]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[18]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[19]),
	.result(temp_result[19]),
	.cout(temp_cout[19])
	);
alu_top  alu20(
	.src1(src1_i[20]),.src2(src2_i[20]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[19]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[20]),
	.result(temp_result[20]),
	.cout(temp_cout[20])
	);
alu_top  alu21(
	.src1(src1_i[21]),.src2(src2_i[21]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[20]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[21]),
	.result(temp_result[21]),
	.cout(temp_cout[21])
	);
alu_top  alu22(
	.src1(src1_i[22]),.src2(src2_i[22]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[21]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[22]),
	.result(temp_result[22]),
	.cout(temp_cout[22])
	);
alu_top  alu23(
	.src1(src1_i[23]),.src2(src2_i[23]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[22]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[23]),
	.result(temp_result[23]),
	.cout(temp_cout[23])
	);
alu_top  alu24(
	.src1(src1_i[24]),.src2(src2_i[24]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[23]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[24]),
	.result(temp_result[24]),
	.cout(temp_cout[24])
	);
alu_top  alu25(
	.src1(src1_i[25]),.src2(src2_i[25]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[24]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[25]),
	.result(temp_result[25]),
	.cout(temp_cout[25])
	);
alu_top  alu26(
	.src1(src1_i[26]),.src2(src2_i[26]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[25]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[26]),
	.result(temp_result[26]),
	.cout(temp_cout[26])
	);
alu_top  alu27(
	.src1(src1_i[27]),.src2(src2_i[27]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[26]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[27]),
	.result(temp_result[27]),
	.cout(temp_cout[27])
	);
alu_top  alu28(
	.src1(src1_i[28]),.src2(src2_i[28]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[27]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[28]),
	.result(temp_result[28]),
	.cout(temp_cout[28])
	);
alu_top  alu29(
	.src1(src1_i[29]),.src2(src2_i[29]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[28]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[29]),
	.result(temp_result[29]),
	.cout(temp_cout[29])
	);
alu_top  alu30(
	.src1(src1_i[30]),.src2(src2_i[30]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[29]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[30]),
	.result(temp_result[30]),
	.cout(temp_cout[30])
	);
alu_top  alu31(
	.src1(src1_i[31]),.src2(src2_i[31]),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[30]),.operation(ctrl_i[1:0]),
	.equal_out(temp_equal_out[31]),
	.result(temp_result[31]),
	.cout(temp_cout[31])
	);
	//turn 32-bit ALU to 33-bit ALU for unsigned operation
alu_bottom alu32(
	.src1(src1_extraMSB),.src2(src2_extraMSB),.less(1'b0),/*.equal(),*/.A_invert(A_invert),.B_invert(ctrl_i[2]),.cin(temp_cout[31]),.operation(ctrl_i[1:0]),
	.set_out(set_out),
	.equal_out(temp_equal_out[32]),
	.result(temp_result[32]),
	.cout(temp_cout[32])
	);
/*ALUCtrl_o signal corresponding to What kind of operation
---------------------------------
ALUCtrl_o,operation             -
   0000  ,   AND                -
   0001  ,   OR                 -
   0010  ,   ADD,LW,SW          -
   0011  ,   Shift_Left         -
   0100  ,   LUI                -
   0101  ,   MUL                -
   0110  ,   SUB,BEQ,BLE,BLT    -
   0111  ,   SLT                -
   1000  ,   JR                 -
   1001  ,   N/A                -
   1010  ,   N/A                -
   1011  ,   N/A                -
   1100  ,   N/A                -
   1101  ,   N/A                -
   1110  ,   BNE,BNEZ           -
   1111  ,   SLTU               -
---------------------------------
*/
//Main function
always @ ( * ) begin
	if(rst==1'b1)
		begin
			case(ctrl_i)
				4'b0011://For Shift Left operation
					begin
						zero_o = ~(|SLL_result);
						result_o = SLL_result;
					end
				4'b0100://For LUI opeartion
					begin
						zero_o = ~(|LUI_result);
						result_o = LUI_result;
					end
				4'b0101://For MUL operation
					begin
						zero_o = ~(|MUL_result);
						result_o = MUL_result;
					end
				4'b1000:
					begin
						zero_o = 1'b1;
						result_o = 32'b0;
					end
				4'b1110://For BNE
					begin
						zero_o = ~(|temp_result[31:0]);
						result_o = temp_result[31:0];
					end
				default://For AND,OR,SLTU,SLT,ADD,SUB,BEQ
					begin
						zero_o = ~(|temp_result[32-1:0]);
						result_o = temp_result[31:0];
					end
			endcase
		end
	else
		begin
			zero_o=1'b0;
			result_o=32'b0;
		end
end
endmodule






