//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:0416315�����416005張彧��//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	Branch_o,
	MemToReg_o,
	BranchType_o,
	Jump_o,
	MemRead_o,
	MemWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegWrite_o,
	RegDst_o
	);

//I/O ports
input  [6-1:0] instr_op_i;

output  Branch_o;
output [2-1:0] MemToReg_o;
output [2-1:0] BranchType_o;//Need to know certain bits
output  Jump_o;     //Need to know certain bits
output  MemRead_o;
output  MemWrite_o;
output [3-1:0] ALU_op_o;
output  ALUSrc_o;
output  RegWrite_o;
//output  RegDst_o;
output [2-1:0] RegDst_o;
//Internal Signals
reg  Branch_o;
reg [2-1:0] MemToReg_o;
reg [2-1:0] BranchType_o;
reg  Jump_o;
reg  MemRead_o;
reg  MemWrite_o;
reg [3-1:0] ALU_op_o;
reg  ALUSrc_o;
reg  RegWrite_o;
//reg  RegDst_o;
reg [2-1:0] RegDst_o;
//Parameter
/*ALU_op_o signal corresponding to What kind of operation
---------------------------------
ALU_op_o,set of operation      -
   000  ,   R-type             -
   001  ,   BEQ,BLT,BLE        -
   010  ,   BNE,BNEZ           -
   011  ,   Addi,lw,sw         -
   100  ,   LUI                -
   101  ,   ORI                -
   110  ,   LI                 -//Need confirmation
   111  ,   Don't care use     -
---------------------------------
*/
//Main function
always @ ( * ) begin
	case (instr_op_i)
		6'd0://R-type
			begin
				Branch_o = 1'b0;
				MemToReg_o = 2'b00;
				BranchType_o = 2'b00;
				Jump_o = 1'b0;
				MemRead_o = 1'b0;
				MemWrite_o = 1'b0;
				ALU_op_o = 3'b000;
				ALUSrc_o = 1'b0;
				RegWrite_o = 1'b1;
				RegDst_o = 2'b01;
			end
		6'd2://For Jump
			begin
				Branch_o = 1'b0;     //Don't care
				MemToReg_o = 2'b00;  //Don't care
				BranchType_o = 2'b00;//Don't care
				Jump_o = 1'b1;
				MemRead_o = 1'b0;
				MemWrite_o = 1'b0;
				ALU_op_o = 3'b111;   //Don't care
				ALUSrc_o = 1'b0;     //Don't care
				RegWrite_o = 1'b0;
				RegDst_o = 2'b00;    //Don't care
			end
		6'd3://For JAL
			begin
				Branch_o = 1'b0;     //Don't care
				MemToReg_o = 2'b11;
				BranchType_o = 2'b00;//Don't care
				Jump_o = 1'b1;
				MemRead_o = 1'b0;
				MemWrite_o = 1'b0;
				ALU_op_o = 3'b111;   //Don't care
				ALUSrc_o = 1'b0;     //Don't care
				RegWrite_o = 1'b1;
				RegDst_o = 2'b10;      //Don't care
			end
		6'd4://Branch Equal
			begin
				Branch_o = 1'b1;
				MemToReg_o = 2'b00;  //Don't care
				BranchType_o = 2'b00;
				Jump_o = 1'b0;
				MemRead_o = 1'b0;
				MemWrite_o = 1'b0;
				ALU_op_o = 3'b001;
				ALUSrc_o = 1'b0;
				RegWrite_o = 1'b0;
				RegDst_o = 2'b00;   //Don't care
			end
		6'd5://Brach not Equal, BNEZ(Need more check)
			begin
				Branch_o = 1'b1;
				MemToReg_o = 2'b00;  //Don't care
				BranchType_o = 2'b11;
				Jump_o = 1'b0;
				MemRead_o = 1'b0;
				MemWrite_o = 1'b0;
				ALU_op_o = 3'b010;
				ALUSrc_o = 1'b0;
				RegWrite_o = 1'b0;
				RegDst_o = 2'b00;     //Don't care
			end
		6'd6://For BLT
			begin
				Branch_o = 1'b1;
				MemToReg_o = 2'b00;  //Don't care
				BranchType_o = 2'b10;
				Jump_o = 1'b0;
				MemRead_o = 1'b0;
				MemWrite_o = 1'b0;
				ALU_op_o = 3'b001;
				ALUSrc_o = 1'b0;
				RegWrite_o = 1'b0;
				RegDst_o = 2'b00;   //Don't care
			end
		6'd7://For BLE
			begin
				Branch_o = 1'b1;
				MemToReg_o = 2'b00;  //Don't care
				BranchType_o = 2'b01;
				Jump_o = 1'b0;
				MemRead_o = 1'b0;
				MemWrite_o = 1'b0;
				ALU_op_o = 3'b001;
				ALUSrc_o = 1'b0;
				RegWrite_o = 1'b0;
				RegDst_o = 2'b00;//Don't care
			end
		6'd8://Addi
			begin
				Branch_o = 1'b0;
				MemToReg_o = 2'b00;
				BranchType_o = 2'b00;
				Jump_o = 1'b0;
				MemRead_o = 1'b0;
				MemWrite_o = 1'b0;
				ALU_op_o = 3'b011;
				ALUSrc_o = 1'b1;
				RegWrite_o = 1'b1;
				RegDst_o = 2'b00;
			end
		6'd13://For ORI
			begin
				Branch_o = 1'b0;
				MemToReg_o = 2'b00;
				BranchType_o = 2'b00;
				Jump_o = 1'b0;
				MemRead_o = 1'b0;
				MemWrite_o = 1'b0;
				ALU_op_o = 3'b101;
				ALUSrc_o = 1'b1;
				RegWrite_o = 1'b1;
				RegDst_o = 2'b00;
			end
		6'd15://For LI
			begin
				Branch_o = 1'b0;
				MemToReg_o = 2'b10;
				BranchType_o = 2'b00;
				Jump_o = 1'b0;
				MemRead_o = 1'b0;
				MemWrite_o = 1'b0;
				ALU_op_o = 3'b110;
				ALUSrc_o = 1'b0;
				RegWrite_o = 1'b1;
				RegDst_o = 2'b00;
			end
		6'd35://For LW
			begin
				Branch_o = 1'b0;
				MemToReg_o = 2'b01;
				BranchType_o = 2'b00;//It's don't care
				Jump_o = 1'b0;
				MemRead_o = 1'b1;
				MemWrite_o = 1'b0;
				ALU_op_o = 3'b011;   //Same as addi
				ALUSrc_o = 1'b1;
				RegWrite_o = 1'b1;
				RegDst_o = 2'b00;
			end
		6'd43://For SW
			begin
				Branch_o = 1'b0;
				MemToReg_o = 2'b00;  //don't care
				BranchType_o = 2'b00;//don't care
				Jump_o = 1'b0;
				MemRead_o = 1'b0;
				MemWrite_o = 1'b1;
				ALU_op_o = 3'b011;   //Same as addi
				ALUSrc_o = 1'b1;
				RegWrite_o = 1'b0;
				//RegDst_o = 1'b1;     //don't care
				RegDst_o = 2'b01;
			end
		default:
			begin
				Branch_o = 1'b0;
				MemToReg_o = 2'b00;
				BranchType_o = 2'b00;
				Jump_o = 1'b0;
				MemRead_o = 1'b0;
				MemWrite_o = 1'b0;
				ALU_op_o = 3'b000;
				ALUSrc_o = 1'b0;
				RegWrite_o = 1'b0;
				//RegDst_o = 1'b0;
				RegDst_o = 2'b00;
			end
	endcase
end
endmodule






