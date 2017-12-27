//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:0416315��416005張彧��/----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
//Done
/*
0502 Comments
add branch mux(4-1)//Done
add brach_target mux(2-1)//Done
add memory mux(4-1)//Done
modify the pc source mux to jump mux//Done
*/
module Simple_Single_CPU(
        clk_i,
		rst_i
		);

//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
/*For SLL instruction*/
wire [32-1:0] shamt;

/*For PC Module*/
wire [32-1:0] pc_number;
wire [32-1:0] pc_number_next;
wire [32-1:0] pc_number_in;
wire [32-1:0] pc_plus_four;

/*For IM Module*/
wire [32-1:0] instruction_o;

/*For Reg_File Module*/
wire [5-1:0]  WriteReg;
wire [32-1:0] RSdata_o;
wire [32-1:0] RTdata_o;

/*For Decoder Module*/
wire  Branch_o;
wire [2-1:0] MemToReg_o;
wire [2-1:0] BranchType_o;
wire  Jump_o;
wire  MemRead_o;
wire  MemWrite_o;
wire [3-1:0] ALU_op_o;
wire  ALUSrc_2_o;
wire  RegWrite_o;
//wire  RegDst_o;
wire [2-1:0] RegDst_o;
wire Jump_type;
/*For ALU_Ctrl Module*/
wire ALUSrc_1_o;
wire [4-1:0] ALUCtrl_o;

/*For Sign_Extend Module*/
wire [32-1:0] SE_data_o;

/*For ALU Module*/
wire [32-1:0] ALU_src_1;
wire [32-1:0] ALU_src_2;
wire [32-1:0] result_o;
wire zero_o;

/*For Memory Module*/
wire [32-1:0] MEM_Read_data_o;

/*For MUX_2to1*/
wire [32-1:0] Jump_address;

/*For MUX_4to1*/
wire [32-1:0] WB_data_o;
wire [32-1:0] Branch_MUX_out;
wire type_branch_o;

/*For Adder_For_BranchTarget*/
wire [32-1:0] Branch_target;

/*For Shift_Left_Two_32 Module*/
wire [32-1:0] SL_32_data_o;

wire Branch_signal;
assign shamt = {27'b0,instruction_o[10:6]};
assign Branch_signal = Branch_o & type_branch_o;

//Greate componentes
ProgramCounter PC(
		//Done
        .clk_i(clk_i),
	    .rst_i (rst_i),
	    .pc_in_i(pc_number_in),
		//.pc_in_i(pc_number_next),
		.pc_out_o(pc_number)
	    );

Adder Adder_For_Instruction(
		//Done
        .src1_i(pc_number),
	    .src2_i(32'd4),
	    .sum_o(pc_plus_four)
	    );

Instr_Memory IM(
		//Done
        .pc_addr_i(pc_number),
	    .instr_o(instruction_o)
	    );
//First MUX
/*MUX_2to1 #(.size(5)) Mux_Write_Reg_Select(
		//Done
        .data0_i(instruction_o[20:16]),
        .data1_i(instruction_o[15:11]),
        .select_i(RegDst_o),
        .data_o(WriteReg)
        );
*/
//Improved version of First MUX
MUX_4to1 #(.size(5)) Mux_Write_Reg_Select(
		.data0_i(instruction_o[20:16]),
		.data1_i(instruction_o[15:11]),
		.data2_i(5'd31),
		.data3_i(5'd0),//For future use
		.select_i(RegDst_o),
		.data_o(WriteReg)
		);
//Second MUX
MUX_2to1 #(.size(32)) Mux_ALUSrc_1(
		//Done
        .data0_i(RSdata_o),
        .data1_i(shamt),
        .select_i(ALUSrc_1_o),
        .data_o(ALU_src_1)
        );
//Third MUX
MUX_2to1 #(.size(32)) Mux_ALUSrc_2(
		//Done
        .data0_i(RTdata_o),
        .data1_i(SE_data_o),
        .select_i(ALUSrc_2_o),
        .data_o(ALU_src_2)
        );
//Forth MUX
MUX_4to1 #(.size(32)) Mux_MEM(
	.data0_i(result_o),
	.data1_i(MEM_Read_data_o),
	.data2_i(SE_data_o),
	.data3_i(pc_plus_four),
	.select_i(MemToReg_o),
	.data_o(WB_data_o)
	);
//Fifth MUX
MUX_4to1 #(.size(1)) Mux_Branch_Type(
	.data0_i(zero_o),//BEQ
	.data1_i((zero_o|result_o[31])),//BLE
	.data2_i(result_o[31]),//BLT
	.data3_i(~zero_o),//BNE,BNEZ
	.select_i(BranchType_o),
	.data_o(type_branch_o)
	);
//Sixth MUX
MUX_2to1 #(.size(32)) Mux_Branch(
		//Done
        .data0_i(pc_plus_four),
        .data1_i(Branch_target),
        .select_i(Branch_signal),
        .data_o(Branch_MUX_out)
        );
//seven MUX
MUX_2to1 #(.size(32)) Mux_Jump(
		//Done
        .data0_i(Branch_MUX_out),
        .data1_i({pc_plus_four[31:28],instruction_o[25:0],2'b00}),
        .select_i(Jump_o),
        .data_o(pc_number_next)
        );
//eight MUX in the last stage
MUX_2to1 #(.size(32)) Select_Final_address(
		//Done
        .data0_i(pc_number_next),
        .data1_i(RSdata_o),
        .select_i(Jump_type),
        .data_o(pc_number_in)
        );
Reg_File RF(
		//Done
        .clk_i(clk_i),
	    .rst_i(rst_i),
        .RSaddr_i(instruction_o[25:21]),
        .RTaddr_i(instruction_o[20:16]),
        .RDaddr_i(WriteReg),
        .RDdata_i(WB_data_o),
        .RegWrite_i (RegWrite_o),
        .RSdata_o(RSdata_o),
        .RTdata_o(RTdata_o)
        );

Decoder Decoder(
		//Done
        .instr_op_i(instruction_o[31:26]),
	    .Branch_o(Branch_o),
		.MemToReg_o(MemToReg_o),
		.BranchType_o(BranchType_o),
		.Jump_o(Jump_o),
		.MemRead_o(MemRead_o),
		.MemWrite_o(MemWrite_o),
		.ALU_op_o(ALU_op_o),
		.ALUSrc_o(ALUSrc_2_o),
		.RegWrite_o(RegWrite_o),
		.RegDst_o(RegDst_o)
	    );

ALU_Ctrl AC(
		//Done
        .funct_i(instruction_o[5:0]),
        .ALUOp_i(ALU_op_o),
        .ALUCtrl_o(ALUCtrl_o),
		.ALUSrc_1_o(ALUSrc_1_o),
		.Jump_type(Jump_type)
        );

Sign_Extend SE(
		//Done
        .data_i(instruction_o[16-1:0]),
        .data_o(SE_data_o)
        );

ALU ALU(
		//Done
		.rst(rst_i),
        .src1_i(ALU_src_1),
	    .src2_i(ALU_src_2),
	    .ctrl_i(ALUCtrl_o),
	    .result_o(result_o),
		.zero_o(zero_o)
	    );

Data_Memory MEM(
	.clk_i(clk_i),
	.addr_i(result_o),
	.data_i(RTdata_o),
	.MemRead_i(MemRead_o),
	.MemWrite_i(MemWrite_o),
	.data_o(MEM_Read_data_o)
	);

Adder Adder_For_BranchTarget(
		//Done
        .src1_i(pc_plus_four),
	    .src2_i(SL_32_data_o),
	    .sum_o(Branch_target)
	    );

Shift_Left_Two_32 Shifter(
		//Done
        .data_i(SE_data_o),
        .data_o(SL_32_data_o)
        );

endmodule



