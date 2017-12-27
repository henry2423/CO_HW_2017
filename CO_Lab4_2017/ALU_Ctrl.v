module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o, Jr_o ,sr_sl_o ,Slv_o);

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
//Jr
output	   Jr_o;
output     sr_sl_o;
output 	   Slv_o;
     
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;


//Main function
/*your code here*/

assign FURslt_o = (ALUOp_i == 3'b010 && funct_i == 6'b000000)? 2'b01 :	//sll	
				  (ALUOp_i == 3'b010 && funct_i == 6'b000010)? 2'b01 :	//srl
				  (ALUOp_i == 3'b010 && funct_i == 6'b000100)? 2'b01 :	//sllv
				  (ALUOp_i == 3'b010 && funct_i == 6'b000110)? 2'b01 :	//srlv
				  (ALUOp_i == 3'b101)?   					   2'b10 :	//lui
				  (ALUOp_i == 3'b010 || ALUOp_i == 3'b000 || ALUOp_i == 3'b100)?    2'b00 :	//lw sw r type addi
				  											   2'b00 ;	//don't care

assign ALU_operation_o = (ALUOp_i == 3'b100)? 4'b0010 :	//addi
				  	     (ALUOp_i == 3'b010 && funct_i == 6'b100000)? 4'b0010 :	//add
				         (ALUOp_i == 3'b010 && funct_i == 6'b100010)? 4'b0110 :	//sub
				         (ALUOp_i == 3'b010 && funct_i == 6'b100100)? 4'b0000 :	//and
				         (ALUOp_i == 3'b010 && funct_i == 6'b100101)? 4'b0001 :	//or
				         (ALUOp_i == 3'b010 && funct_i == 6'b101010)? 4'b0111 :	//slt
				         (ALUOp_i == 3'b010 && funct_i == 6'b100111)? 4'b1100 : //nor
				         //(ALUOp_i == 3'b010 && funct_i == 6'b000000)? 4'b0101 :	//when sll
				  		 //(ALUOp_i == 3'b010 && funct_i == 6'b000010)? 4'b0100 : //when srl
				  		 //(ALUOp_i == 3'b010 && funct_i == 6'b000100)? 4'b0001 : //when sllv
						 //(ALUOp_i == 3'b010 && funct_i == 6'b000110)? 4'b0000 : //when srlv
						 (ALUOp_i == 3'b010 && funct_i == 6'b001000)? 4'b1111 :	//Jr
						 (ALUOp_i == 3'b111)?						  4'b0111 :	//blt
						 (ALUOp_i == 3'b011)?						  4'b0110 : //bqez rs - 1
						 (ALUOp_i == 3'b000)?						  4'b0010 : //lw sw do add
						 (ALUOp_i == 3'b001)?						  4'b0110 : //beq
						 (ALUOp_i == 3'b110)?						  4'b0110 : //bne
				  		 											  4'b1111 ;	//don't care

assign Jr_o = (ALUOp_i == 3'b010 && funct_i == 6'b001000)? 1:	//Jr_mux 設定
										 					0;


assign sr_sl_o = (ALUOp_i == 3'b010 && funct_i == 6'b000000)? 1 :	//when sll
				 (ALUOp_i == 3'b010 && funct_i == 6'b000010)? 0 : //when srl
				 (ALUOp_i == 3'b010 && funct_i == 6'b000100)? 1 : //when sllv
				 (ALUOp_i == 3'b010 && funct_i == 6'b000110)? 0 : //when srlv	
				 											  0;																  
assign Slv_o = (ALUOp_i == 3'b010 && funct_i == 6'b000000)? 1 :	//when sll
				 (ALUOp_i == 3'b010 && funct_i == 6'b000010)? 1 : //when srl
				 (ALUOp_i == 3'b010 && funct_i == 6'b000100)? 0 : //when sllv
				 (ALUOp_i == 3'b010 && funct_i == 6'b000110)? 0 : //when srlv	
				 											  0;																		 


endmodule     


/*

always @ ( * ) begin
	case(ALUOp_i)
		3'b000://R-type structure instruction
			begin
				case(funct_i)
					6'd32: {Slv_o,ALU_operation_o,Jump_type}=6'b000100;//Addition
					6'd34: {Slv_o,ALU_operation_o,Jump_type}=6'b001100;//Subtraction
					6'd36: {Slv_o,ALU_operation_o,Jump_type}=6'b000000;//AND
					6'd37: {Slv_o,ALU_operation_o,Jump_type}=6'b000010;//OR
					6'd42: {Slv_o,ALU_operation_o,Jump_type}=6'b001110;//SLT
					6'd8: {Slv_o,ALU_operation_o,Jump_type}=6'b010001;//JR
					6'b000000: {Slv_o,ALU_operation_o,Jump_type}=6'b100110;//SLL
					6'b000010: {Slv_o,ALU_operation_o,Jump_type}=6'b100110;//SRL
					6'b000100: {Slv_o,ALU_operation_o,Jump_type}=6'b000110;//SLLV
					6'b000110: {Slv_o,ALU_operation_o,Jump_type}=6'b000110;//SRLV
				endcase
			end
		3'b001://BEQ,BLT,BLE
			begin
				{Slv_o,ALU_operation_o,Jump_type} = 6'b001100;
			end
		3'b010://BNE,BNEZ
			begin
				{Slv_o,ALU_operation_o,Jump_type} = 6'b011100;
			end
		3'b100://Addi
			begin
				{Slv_o,ALU_operation_o,Jump_type} = 6'b000100;
			end
			
		3'b100://LI
			begin
				{Slv_o,ALU_operation_o,Jump_type} = 6'b001000;
			end
		3'b101://ORI
			begin
				{Slv_o,ALU_operation_o,Jump_type} = 6'b000010;
			end
			
		default:
			begin
				Slv_o = 1'b0;
				ALU_operation_o=4'bxxxx;
				Jump_type = 1'b0;
			end
	endcase
end
*/