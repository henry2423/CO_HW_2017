module ALU_1bit( result, carryOut, a, b, invertA, invertB, operation, carryIn, less ); 
  
  output wire result;
  output wire carryOut;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  /*your code here*/ 

  wire add_result, add_carryOut;
  wire in_a;
  wire in_b;
  assign in_a = invertA? ~a: a; 
  assign in_b = invertB? ~b: b;
  
  Full_adder FA(add_result, add_carryOut, carryIn, in_a, in_b);

  assign result = (operation == 2'b00) ?  in_a & in_b:
                  (operation == 2'b01) ?  in_a | in_b :
                  (operation == 2'b10) ?  add_result:
                                          less;

  assign carryOut = (operation == 2'b00) ?  0 :
                    (operation == 2'b01) ?  0 :
                    (operation == 2'b10) ?  add_carryOut:
                                            add_carryOut;               
endmodule

module ALU_1bit_32( result, carryOut, a, b, invertA, invertB, operation, carryIn, less, set); 
  
  output wire result;
  output wire carryOut;
  output wire set;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  /*your code here*/ 

  wire add_result, add_carryOut;
  wire in_a;
  wire in_b;
  assign in_a = invertA? ~a: a; 
  assign in_b = invertB? ~b: b;
  
  Full_adder FA(add_result, add_carryOut, carryIn, in_a, in_b);

  assign result = (operation == 2'b00) ?  in_a & in_b:
                  (operation == 2'b01) ?  in_a | in_b :
                  (operation == 2'b10) ?  add_result:
                                          less;

  assign carryOut = (operation == 2'b00) ?  0 :
                    (operation == 2'b01) ?  0 :
                    (operation == 2'b10) ?  add_carryOut:
                                            add_carryOut;  

  assign set = (operation == 2'b11)? add_result:
                                     0;

endmodule