module Mux2to1( data0_i, data1_i, select_i, data_o );

parameter size = 0;			   
			
//I/O ports               
input wire	[size-1:0] data0_i;          
input wire	[size-1:0] data1_i;
input wire	select_i;
output wire	[size-1:0] data_o; 

//Main function
/*your code here*/
assign data_o =  (select_i == 1'd0)? data0_i:
								     data1_i;

endmodule      
    