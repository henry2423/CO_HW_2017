module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o ,Branch_o, Branch_type, Jump_o, MemRead_o, MemWrite_o, MemtoReg_o);
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;

//lab4
output			Branch_o;
output			Branch_type;
output			Jump_o;
output			MemRead_o;
output 			MemWrite_o;
output			MemtoReg_o;		//2個 00 from mem;  01 not through mem

 
//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire			RegDst_o;

//Main function
/*your code here*/
/*assign  RegWrite_o = (instr_op_i == 6'b001000)? 1:		//addi
				     (instr_op_i == 6'b001111)? 1:		//lui
					 (instr_op_i == 6'b100011)? 1:		//lw
				     							1;
*/

assign  RegWrite_o = (instr_op_i == 6'b101011 || instr_op_i == 6'b000100 || instr_op_i == 6'b000101 || instr_op_i == 6'b000010 || instr_op_i == 6'b000110 || instr_op_i == 6'b000001)? 0:		//sw beq bne j blt bnez bgez
				     																											 1;


/*assign  ALUOp_o = (instr_op_i == 6'b001000)? 3'b100:	//addi
				  (instr_op_i == 6'b001111)? 3'b101:	//lui
				     					     3'b010;
*/

assign  ALUOp_o = (instr_op_i == 6'b100011 || instr_op_i == 6'b101011)? 3'b000:	//lw sw
				  (instr_op_i == 6'b000100)? 3'b001:	//beq
				  (instr_op_i == 6'b000101)? 3'b110:	//bne bnez
				  (instr_op_i == 6'b000110)? 3'b111:	//blt
				  (instr_op_i == 6'b000001)? 3'b011:	//bgez
				  (instr_op_i == 6'b000000)? 3'b010:	//R type (sll srl sllv srlv)
				  (instr_op_i == 6'b001000)? 3'b100:	//addi
				  (instr_op_i == 6'b001111)? 3'b101:	//lui
				     					     3'b111;	//else don't care 
/*
assign  ALUSrc_o = (instr_op_i == 6'b001000)? 1:	 //addi
				   (instr_op_i == 6'b001111)? 1:	//lui
				     						  0;
*/									

assign  ALUSrc_o = (instr_op_i == 6'b100011)? 1:	 //lw
				   (instr_op_i == 6'b101011)? 1:	 //sw
				   (instr_op_i == 6'b001000)? 1:	 //addi
				   (instr_op_i == 6'b001111)? 1:	 //lui
				   (instr_op_i == 6'b000001)? 1:	 //bgez load 1
				     						  0;											   

assign  RegDst_o = (instr_op_i == 6'b001000)? 0:	//addi
				   (instr_op_i == 6'b001111)? 0:	//lui
				   (instr_op_i == 6'b100011)? 0:	//lui
				     						  1;

//lab4
assign	Branch_o = (instr_op_i == 6'b000100 || instr_op_i == 6'b000101 || instr_op_i == 6'b000110 || instr_op_i == 6'b000001)? 1:	//beq, bne, blt, bnez先設定1 再simple_cpu判斷
																															   0;

assign  Branch_type = (instr_op_i == 6'b000100)? 1'b0:	//beq 看mux = 0
												 1'b1;	//bne blt bnez看mux = 1
/*				   														 			  			  
assign  Branch_type = (instr_op_i == 6'b000100)? 2'b00:	//beq 看mux = 0
				      (instr_op_i == 6'b000100)? 2'b10:	//bgez 
												 2'b01;	//bne blt bnez看mux = 1
*/

assign	Jump_o = (instr_op_i == 6'b000010)? 1:	//jump 
				     						0;

assign	MemRead_o = (instr_op_i == 6'b100011)? 1:	//lw
				        					   0;	
										
assign	MemWrite_o = (instr_op_i == 6'b101011)? 1:	//sw
				     						    0;

assign	MemtoReg_o = (instr_op_i == 6'b100011 || instr_op_i == 6'b101011)? 1:	//lw or sw 要經過 mem
																		   0;


endmodule
   