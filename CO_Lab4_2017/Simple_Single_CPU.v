module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [31:0] pc_final;
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
//lab4
wire Branch;
wire [1:0] Branch_type_select;
wire Branch_type;
wire Jump;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire [31:0] Mem_wirteback_data;
wire [31:0] Mem_data_o;
wire [31:0] branch_pc;
wire [31:0] after_branch_new_pc;
wire PCSrc;
wire zero;
wire overflow;
//Jal Jr
wire Jal_reg_data_sel;
wire Jr_sel;
wire [4:0] instruction_RDdata;
wire [31:0] Jump_choose_o;
wire [31:0] Reg_write_data_o;
wire leftRight_sel;
wire Shifter_shamt_sel;


assign PCSrc = (Branch && Branch_type);

//modules
Program_Counter PC(
            .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_final) ,   
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
        .data_o(instruction_RDdata)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_n(rst_n) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(RDdata) ,  
        .RDdata_i(Reg_write_data_o) , 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata) ,  
        .RTdata_o(RTdata)   
        );
	
Decoder Decoder(
            .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),
            .Branch_o(Branch),
            .Jump_o(Jump),
            .Branch_type(Branch_type_select),
            .MemRead_o(MemRead),
            .MemWrite_o(MemWrite),
            .MemtoReg_o(MemtoReg),
            .Jal_reg_data_o(Jal_reg_data_sel)  
		);

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALU_operation_o(ALU_operation),
	.FURslt_o(FURslt),
        .Jr_o(Jr_sel),
        .sr_sl_o(leftRight_sel),
        .Slv_o(Shifter_shamt_sel)
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

Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(Mem_wirteback_data), 
        .data_i(RTdata),        //reg_rt write to memory
        .MemRead_i(MemRead),
        .MemWrite_i(MemWrite), 
        .data_o(Mem_data_o)
        );


Mux2to1 #(.size(32)) Shifter_shamt(
        .data0_i(RSdata),
        .data1_i({27'b000000000000000000000000000, instr[10:6]}),
        .select_i(Shifter_shamt_sel),
        .data_o(shift_shamt)
        );	
		
Shifter shifter( 
		.result(shift_result), 
		.leftRight(leftRight_sel),
		.shamt(shift_shamt),
		.sftSrc(to_aluSrc2) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(ALU_result),
        .data1_i(shift_result),
	.data2_i(zero_fill),
        .select_i(FURslt),
        .data_o(Mem_wirteback_data)
        );

Mux2to1 #(.size(32)) MemtoReg_mux(
        .data0_i(Mem_wirteback_data),
        .data1_i(Mem_data_o),
        .select_i(MemtoReg),
        .data_o(write_back_data)
        );

//branch related setting
Mux3to1 #(.size(1)) Branch_type_mux(
        .data0_i(zero),
        .data1_i(~zero),
	.data2_i(~ALU_result[31]),
        .select_i(Branch_type_select),
        .data_o(Branch_type)
        );

Adder Adder_for_branch(
                .src1_i(pc_add),     
	        .src2_i(sign_ext << 2),
	        .sum_o(branch_pc)    
	        );

Mux2to1 #(.size(32)) Branch_choose(
        .data0_i(pc_add),
        .data1_i(branch_pc),
        .select_i(PCSrc),
        .data_o(after_branch_new_pc)
        ); 

Mux2to1 #(.size(32)) Jump_choose(
        .data0_i(after_branch_new_pc),
        .data1_i({pc_add[31:28], instr[25:0], 2'b00}),
        .select_i(Jump),
        .data_o(Jump_choose_o)
        ); 

//Jal Jr
Mux2to1 #(.size(5)) Jal_reg_mux(
        .data0_i(instruction_RDdata),
        .data1_i(5'd31),
        .select_i(Jal_reg_data_sel),
        .data_o(RDdata)
        ); 

Mux2to1 #(.size(32)) Jal_data_mux(
        .data0_i(write_back_data),
        .data1_i(pc_add),
        .select_i(Jal_reg_data_sel),
        .data_o(Reg_write_data_o)
        );   

Mux2to1 #(.size(32)) Jr_choose_mux(
        .data0_i(Jump_choose_o),
        .data1_i(RSdata),
        .select_i(Jr_sel),
        .data_o(pc_final)
        );  


endmodule



