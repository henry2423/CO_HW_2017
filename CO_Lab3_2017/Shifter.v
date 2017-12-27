module Shifter( result, leftRight, shamt, sftSrc );

//I/O ports 
output	[32-1:0] result;

input			leftRight;
input	[32-1:0] shamt;
input	[32-1:0] sftSrc ;

//Internal Signals
wire	[32-1:0] result;
  
//Main function
/*your code here*/
assign result = (leftRight == 1'b0)? sftSrc >> shamt:	//when srl from alu_ctrl
  				  				  	 sftSrc << shamt;

endmodule