`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    18:06:58 02/25/2016
// Design Name:
// Module Name:    testbench
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`define CYCLE_TIME 50

module TestBench;
  reg Clk, Start;
 // reg [31:0] i;

  Simple_Single_CPU CPU(Clk,Start);

  initial
  begin
    Clk = 0;
    Start = 0;

    #(`CYCLE_TIME)

    Start = 1;
    #(`CYCLE_TIME*400)

  $finish;
  end

  always@(posedge Clk) begin
  	$display("------------------------------------------------------------------------------------------------------");
  	 $display("PC = %d", CPU.PC.pc_out_o);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d", CPU.MEM.memory[0], CPU.MEM.memory[1], CPU.MEM.memory[2], CPU.MEM.memory[3], CPU.MEM.memory[4], CPU.MEM.memory[5], CPU.MEM.memory[6], CPU.MEM.memory[7]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d", CPU.MEM.memory[8], CPU.MEM.memory[9], CPU.MEM.memory[10], CPU.MEM.memory[11], CPU.MEM.memory[12], CPU.MEM.memory[13], CPU.MEM.memory[14], CPU.MEM.memory[15]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d", CPU.MEM.memory[16], CPU.MEM.memory[17], CPU.MEM.memory[18], CPU.MEM.memory[19], CPU.MEM.memory[20], CPU.MEM.memory[21], CPU.MEM.memory[22], CPU.MEM.memory[23]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d", CPU.MEM.memory[24], CPU.MEM.memory[25], CPU.MEM.memory[26], CPU.MEM.memory[27], CPU.MEM.memory[28], CPU.MEM.memory[29], CPU.MEM.memory[30], CPU.MEM.memory[31]);
    $display("Registers");
    $display("R0 = %d, R1 = %d, R2 = %d, R3 = %d, R4 = %d, R5 = %d, R6 = %d, R7 = %d", CPU.RF.Reg_File[ 0], CPU.RF.Reg_File[ 1], CPU.RF.Reg_File[ 2], CPU.RF.Reg_File[ 3], CPU.RF.Reg_File[ 4], CPU.RF.Reg_File[ 5], CPU.RF.Reg_File[ 6], CPU.RF.Reg_File[ 7]);
    $display("R8 = %d, R9 = %d, R10 =%d, R11 =%d, R12 =%d, R13 =%d, R14 =%d, R15 =%d", CPU.RF.Reg_File[ 8], CPU.RF.Reg_File[ 9], CPU.RF.Reg_File[10], CPU.RF.Reg_File[11], CPU.RF.Reg_File[12], CPU.RF.Reg_File[13], CPU.RF.Reg_File[14], CPU.RF.Reg_File[15]);
    $display("R16 =%d, R17 =%d, R18 =%d, R19 =%d, R20 =%d, R21 =%d, R22 =%d, R23 =%d", CPU.RF.Reg_File[16], CPU.RF.Reg_File[17], CPU.RF.Reg_File[18], CPU.RF.Reg_File[19], CPU.RF.Reg_File[20], CPU.RF.Reg_File[21], CPU.RF.Reg_File[22], CPU.RF.Reg_File[23]);
    $display("R24 =%d, R25 =%d, R26 =%d, R27 =%d, R28 =%d, R29 =%d, R30 =%d, R31 =%d", CPU.RF.Reg_File[24], CPU.RF.Reg_File[25], CPU.RF.Reg_File[26], CPU.RF.Reg_File[27], CPU.RF.Reg_File[28], CPU.RF.Reg_File[29], CPU.RF.Reg_File[30], CPU.RF.Reg_File[31]);
	$display("------------------------------------------------------------------------------------------------------");
  end

  always #(`CYCLE_TIME/2) Clk = ~Clk;

endmodule

