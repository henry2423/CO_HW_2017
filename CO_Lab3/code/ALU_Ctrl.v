//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:0416315王定偉、0416005張彧豪
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
		  ALUSrc_1_o,
		  Jump_type
          );

//I/O ports
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;
output ALUSrc_1_o;
output Jump_type;
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg ALUSrc_1_o;
reg Jump_type;
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
//Select exact operations
always @ ( * ) begin
	case(ALUOp_i)
		3'b000://R-type structure instruction
			begin
				case(funct_i)
					6'd32: {ALUSrc_1_o,ALUCtrl_o,Jump_type}=6'b000100;//Addition
					6'd34: {ALUSrc_1_o,ALUCtrl_o,Jump_type}=6'b001100;//Subtraction
					6'd36: {ALUSrc_1_o,ALUCtrl_o,Jump_type}=6'b000000;//AND
					6'd37: {ALUSrc_1_o,ALUCtrl_o,Jump_type}=6'b000010;//OR
					6'd42: {ALUSrc_1_o,ALUCtrl_o,Jump_type}=6'b001110;//SLT
					6'd43: {ALUSrc_1_o,ALUCtrl_o,Jump_type}=6'b011110; //SLTU
					6'd24: {ALUSrc_1_o,ALUCtrl_o,Jump_type}=6'b001010;//MUL
					6'd8: {ALUSrc_1_o,ALUCtrl_o,Jump_type}=6'b010001;//JR
					6'd0: {ALUSrc_1_o,ALUCtrl_o,Jump_type}=6'b100110;//SLL
					6'd4: {ALUSrc_1_o,ALUCtrl_o,Jump_type}=6'b000110;//SLLV
				endcase
			end
		3'b001://BEQ,BLT,BLE
			begin
				{ALUSrc_1_o,ALUCtrl_o,Jump_type} = 6'b001100;
			end
		3'b010://BNE,BNEZ
			begin
				{ALUSrc_1_o,ALUCtrl_o,Jump_type} = 6'b011100;
			end
		3'b011://Addi
			begin
				{ALUSrc_1_o,ALUCtrl_o,Jump_type} = 6'b000100;
			end
		3'b100://LI
			begin
				{ALUSrc_1_o,ALUCtrl_o,Jump_type} = 6'b001000;
			end
		3'b101://ORI
			begin
				{ALUSrc_1_o,ALUCtrl_o,Jump_type} = 6'b000010;
			end
		default:
			begin
				ALUCtrl_o = 1'b0;
				ALUCtrl_o=4'bxxxx;
				Jump_type = 1'b0;
			end
	endcase
end
endmodule






