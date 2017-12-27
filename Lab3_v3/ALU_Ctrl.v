module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
     
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;

//Main function
/*your code here*/
assign FURslt_o = (ALUOp_i == 3'b010 && funct_i == 6'b000000)? 2'b01 :
				  (ALUOp_i == 3'b010 && funct_i == 6'b000010)? 2'b01 :
				  (ALUOp_i == 3'b010 && funct_i == 6'b000100)? 2'b01 :
				  (ALUOp_i == 3'b010 && funct_i == 6'b000110)? 2'b01 :
				  (ALUOp_i == 3'b010 || ALUOp_i == 3'b100)?    2'b00 :
				  											   2'b10 ; //ALUOp_i == 3'b101

assign ALU_operation_o = (ALUOp_i == 3'b100)? 4'b0010 :
				  	     (ALUOp_i == 3'b010 && funct_i == 6'b100000)? 4'b0010 :
				         (ALUOp_i == 3'b010 && funct_i == 6'b100010)? 4'b0110 :
				         (ALUOp_i == 3'b010 && funct_i == 6'b100100)? 4'b0000 :
				         (ALUOp_i == 3'b010 && funct_i == 6'b100101)? 4'b0001 :
				         (ALUOp_i == 3'b010 && funct_i == 6'b101010)? 4'b0111 :
				         (ALUOp_i == 3'b010 && funct_i == 6'b100111)? 4'b1100 :
				         (ALUOp_i == 3'b010 && funct_i == 6'b000000)? 4'b0101 :	//when sll
				  		 (ALUOp_i == 3'b010 && funct_i == 6'b000010)? 4'b0100 : //when sl4
				  		 (ALUOp_i == 3'b010 && funct_i == 6'b000100)? 4'b0001 : //when sllv
				  		 											  4'b0000 ;



endmodule     
