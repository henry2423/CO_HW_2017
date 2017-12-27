module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [31:0] pc_add;
wire [31:0] pc_count;
wire [31:0] instr;
wire RegDst;
wire [4:0] RDdata;
wire RegWrite;
wire [31:0] RSdata;
wire [31:0] RTdata;
wire [2:0] ALUOp;
wire ALUSrc;
wire [31:0] sign_ext;
wire [31:0] to_aluSrc2;
wire [31:0] zero_fill; //furslt 2
wire [3:0] ALU_operation;
wire [1:0] FURslt;
wire [31:0] ALU_result; //furslt 0
wire [31:0] shift_result; //furslt 1
wire [31:0] write_back_data;
wire [31:0] shift_shamt;

wire zero;
wire overflow;



//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_add) ,   
	    .pc_out_o(pc_count) 
	    );
	
Adder Adder1(
        .src1_i(pc_count),     
	    .src2_i(32'd4),
	    .sum_o(pc_add)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_count),  
	    .instr_o(instr)    
	    );

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(RDdata)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(RDdata) ,  
        .RDdata_i(write_back_data)  , 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata) ,  
        .RTdata_o(RTdata)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst)   
		);

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALU_operation_o(ALU_operation),
		.FURslt_o(FURslt)
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(sign_ext)
        );

Zero_Filled ZF(
        .data_i(instr[15:0]),
        .data_o(zero_fill)
        );
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(RTdata),
        .data1_i(sign_ext),
        .select_i(ALUSrc),
        .data_o(to_aluSrc2)
        );	
		
ALU ALU(
		.aluSrc1(RSdata),
	    .aluSrc2(to_aluSrc2),
	    .ALU_operation_i(ALU_operation),
		.result(ALU_result),
		.zero(zero),
		.overflow(overflow)
	    );

Mux2to1 #(.size(32)) Shifter_shamt(
        .data0_i(RSdata),
        .data1_i({27'b000000000000000000000000000, instr[10:6]}),
        .select_i(ALU_operation[2]),
        .data_o(shift_shamt)
        );	
		
Shifter shifter( 
		.result(shift_result), 
		.leftRight(ALU_operation[0]),
		.shamt(shift_shamt),
		.sftSrc(to_aluSrc2) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(ALU_result),
        .data1_i(shift_result),
		.data2_i(zero_fill),
        .select_i(FURslt),
        .data_o(write_back_data)
        );			

endmodule



