`timescale 1ns/1ps
//Subject:     CO project 2 - Test Bench
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:0416315王定偉、0416005張彧豪
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
module alu_bottom(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
			   //equal,
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
			   //bonus_control,
			   set_out,
			   equal_out,
               result,     //1 bit result   (output)
               cout       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
//input 		  equal;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;
//input [3-1:0] bonus_control;

output  equal_out;
output  result;
output  cout;
output  set_out;

reg result;
reg cout;
wire real_src1;     //Real operand_1
wire real_src2;     //Real operand_2
//wire bonus_mux_out; //Result from compare_module

assign equal_out = ~(src1^src2);//Check whether the two bit are same or not
assign set_out = ((~cin)&(real_src2))|((~cin)&(src1))|((src1)&(real_src2));

assign real_src1 = (A_invert)?~src1:src1;
assign real_src2 = (B_invert)?~src2:src2;

/*call compare module*/
/*compare COM1(
	.bonus_control(bonus_control),
	.less(less),
	.equal(equal),
	.bonus_mux_out(bonus_mux_out)
	);
*/
always@( * )
begin
/*--Opeartion MUX below-----------------------------------*/
	case(operation)
		2'b00://For AND and NOR
			begin
				result = real_src1&real_src2;
				cout = 1'b0;
			end
		2'b01://For OR and NAND
			begin
				result = real_src1|real_src2;
				cout = 1'b0;
			end
		2'b10://For Addition and Subtraction
			begin
				result = (real_src1^real_src2)^cin;
				cout = (real_src1&real_src2)|(real_src1&cin)|(real_src2&cin);
			end
		2'b11://For SLT and bonus instruction
			begin
				result = ((~cin)&(real_src2))|((~cin)&(src1))|((src1)&(real_src2));//For set out
				cout = (real_src1&real_src2)|(real_src1&cin)|(real_src2&cin);
			end
		default:
			begin
				result = 1'b0;
				cout = 1'b0;
			end
	endcase
end

endmodule
