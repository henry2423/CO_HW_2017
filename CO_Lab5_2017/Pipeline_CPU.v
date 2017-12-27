module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [31:0] pc_final;
wire [31:0] pc_add; 
wire [31:0] pc_count;
wire [31:0] instr;

/**** ID stage ****/

//control signal
wire [6:0] EX_ID;
wire [2:0] MEM_ID;
wire [1:0] WB_ID;
wire RegDst;
wire ALUSrc;
wire [2:0] ALUOp;
wire [1:0] Branch_type_select;
assign EX_ID = {RegDst, ALUSrc, ALUOp, Branch_type_select};
//1:0 Branch_type_select
//4:2 ALUOp
//5 ALUSrc
//6 RegDst
wire Branch;
wire MemRead;
wire MemWrite;
assign MEM_ID = {Branch, MemRead, MemWrite};
wire MemtoReg;
wire RegWrite;
assign WB_ID = {MemtoReg, RegWrite};

wire [31:0] instr_ID;
wire [31:0] pc_add_ID;
wire [31:0] RSdata;     //RS output
wire [31:0] RTdata;     //RT output   
//wire [4:0] RDdata;      //RD input position
wire [31:0] sign_ext;
wire [31:0] zero_fill;  //furslt 2

/**** EX stage ****/

//control signal
wire [1:0] WB_EX;
wire [2:0] MEM_EX;
wire [6:0] EX_EX;
wire [31:0] pc_add_EX;
wire [31:0] RSdata_EX;
wire [31:0] RTdata_EX;
wire [31:0] imm_value_EX;
wire [31:0] zero_value_EX;
wire [4:0] Shifter_srll_EX;
wire [4:0] RegRt_EX;
wire [4:0] RegRd_EX;
wire [5:0] func_i_EX;
wire [4:0] RDdata_EX; //RD sure in EX stage
wire [31:0] to_aluSrc2;
wire [3:0] ALU_operation;
wire [1:0] FURslt;
wire [31:0] ALU_result; //furslt 0
wire leftRight_sel;
wire Shifter_shamt_sel;
wire [31:0] shift_shamt;
wire [31:0] shift_result; //furslt 1
wire Branch_type;
wire overflow;
wire zero;
wire [31:0] branch_pc;
wire [31:0] Mem_wirteback_data;


/**** MEM stage ****/

//control signal


wire [1:0] WB_MEM;
wire [2:0] MEM_MEM;
wire [31:0] PC_Branch_MEM;
wire [31:0] ALU_MEM;
wire [4:0] RDdata_MEM;
wire [31:0] Mem_WriteData;
wire [31:0] after_branch_new_pc;
wire Branch_type_MEM;
wire PCSrc;
wire [31:0] Mem_data_o;


/**** WB stage ****/

//control signal
wire [31:0] write_back_data;

wire [1:0] WB_WB;
wire [31:0] Memdata_WB;
wire [31:0] ALUdata_WB;
wire [4:0] RDdata_WB;  //write back to RF


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage

Mux2to1 #(.size(32)) Branch_choose(
        .data0_i(pc_add),
        .data1_i(PC_Branch_MEM),
        .select_i(PCSrc),
        .data_o(after_branch_new_pc)
        ); 

Mux2to1 #(.size(32)) Jump_choose(
        .data0_i(after_branch_new_pc),
        .data1_i({pc_add[31:28], instr[25:0], 2'b00}),
        .select_i(1'd0),
        .data_o(pc_final)
        );

Program_Counter PC(
            .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_final),   
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

IFID IFIDreg(
            .clk_i(clk_i), 
            .rst_n(rst_n), 
            .PC_Plus4(pc_add), 
            .Inst(instr),
            .InstReg(instr_ID), 
            .PC_Plus4Reg(pc_add_ID)
            );

//Instantiate the components in ID stage

Reg_File RF(
        .clk_i(clk_i),      
	.rst_n(rst_n) ,     
        .RSaddr_i(instr_ID[25:21]) ,  
        .RTaddr_i(instr_ID[20:16]) ,  
        .Wrtaddr_i(RDdata_WB),  
        .Wrtdata_i(write_back_data) , 
        .RegWrite_i(WB_WB[0]),  //wb RegWrite signal
        .RSdata_o(RSdata) ,  
        .RTdata_o(RTdata)   
        );


Decoder Decoder(
        .instr_op_i(instr_ID[31:26]), 
        .RegWrite_o(RegWrite), 
        .ALUOp_o(ALUOp),   
        .ALUSrc_o(ALUSrc),   
        .RegDst_o(RegDst),
        .Branch_o(Branch),
        .Branch_type(Branch_type_select),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .MemtoReg_o(MemtoReg)
	);

Sign_Extend SE(
        .data_i(instr_ID[15:0]),
        .data_o(sign_ext)
        );

Zero_Filled ZF(
        .data_i(instr_ID[15:0]),
        .data_o(zero_fill)
        );

IDEX IDEXreg(
        .clk_i(clk_i), 
        .rst_n(rst_n),
        .WB(WB_ID),
        .M(MEM_ID),
        .EX(EX_ID),
        .PC_Plus4(pc_add_ID), 
        .DataA(RSdata), 
        .DataB(RTdata), 
        .imm_value(sign_ext), 
        .zero_value(zero_fill), 
        .Shifter(instr_ID[10:6]), //FOR SRL SLL
        .RegRt(instr_ID[15:11]), 
        .RegRd(instr_ID[20:16]),
        .func_i(instr_ID[5:0]),
        .WBreg(WB_EX), 
        .Mreg(MEM_EX), 
        .EXreg(EX_EX), 
        .PC_Plus4reg(pc_add_EX), 
        .DataAreg(RSdata_EX), 
        .DataBreg(RTdata_EX), 
        .imm_valuereg(imm_value_EX), 
        .zero_valuereg(zero_value_EX), 
        .Shifterreg(Shifter_srll_EX), 
        .RegRtreg(RegRt_EX), 
        .RegRdreg(RegRd_EX),
        .func_ireg(func_i_EX)
        );

//Instantiate the components in EX stage

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(RegRd_EX),
        .data1_i(RegRt_EX),
        .select_i(EX_EX[6]),
        .data_o(RDdata_EX)
        );

ALU_Ctrl AC(
        .funct_i(func_i_EX),   
        .ALUOp_i(EX_EX[4:2]),   
        .ALU_operation_o(ALU_operation),
	.FURslt_o(FURslt),
        .sr_sl_o(leftRight_sel),
        .Slv_o(Shifter_shamt_sel)
        );

Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(RTdata_EX),
        .data1_i(imm_value_EX),
        .select_i(EX_EX[5]),
        .data_o(to_aluSrc2)
        );

ALU ALU(
	.aluSrc1(RSdata_EX),
	.aluSrc2(to_aluSrc2),
	.ALU_operation_i(ALU_operation),
	.result(ALU_result),
	.zero(zero),
	.overflow(overflow)
	);


Mux3to1 #(.size(1)) Branch_type_mux(
        .data0_i(zero),
        .data1_i(~zero),
	.data2_i(~ALU_result[31]),
        .select_i(EX_EX[1:0]), //Branch_type_select
        .data_o(Branch_type)
        );

Adder Adder_for_branch(
        .src1_i(pc_add_EX),     
        .src2_i(imm_value_EX << 2),
        .sum_o(branch_pc)    
        );

Mux2to1 #(.size(32)) Shifter_shamt(
        .data0_i(RSdata_EX),
        .data1_i({27'b000000000000000000000000000, Shifter_srll_EX}),
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
	.data2_i(zero_value_EX),
        .select_i(FURslt),
        .data_o(Mem_wirteback_data)
        );

EXMEM EXMEMreg(
        .clk_i(clk_i),
        .rst_n(rst_n), 
        .WB(WB_EX), 
        .M(MEM_EX),
        .PC_Branch(branch_pc), 
        .ALUOut(Mem_wirteback_data), 
        .RegRD(RDdata_EX), 
        .Mem_WriteData(RTdata_EX),
        .Branch_type_out(Branch_type),  
        .WBreg(WB_MEM), 
        .Mreg(MEM_MEM), 
        .PC_Branchreg(PC_Branch_MEM), 
        .ALUreg(ALU_MEM), 
        .RegRDreg(RDdata_MEM), 
        .Mem_WriteDatareg(Mem_WriteData),
        .Branch_typereg(Branch_type_MEM)
        );
	
//Instantiate the components in MEM stage

Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(ALU_MEM), 
        .data_i(Mem_WriteData),        //reg_rt write to memory
        .MemRead_i(MEM_MEM[1]),
        .MemWrite_i(MEM_MEM[0]), 
        .data_o(Mem_data_o)
        );

assign PCSrc = (MEM_MEM[2] && Branch_type_MEM);

MEMWB MEMWBreg(
        .clk_i(clk_i), 
        .rst_n(rst_n), 
        .WB(WB_MEM), 
        .Memout(Mem_data_o), 
        .ALUOut(ALU_MEM), 
        .RegRD(RDdata_MEM),  
        .WBreg(WB_WB), 
        .Memreg(Memdata_WB), 
        .ALUreg(ALUdata_WB), 
        .RegRDreg(RDdata_WB)
        );

//Instantiate the components in WB stage


Mux2to1 #(.size(32)) MemtoReg_mux(
        .data0_i(ALUdata_WB),
        .data1_i(Memdata_WB),
        .select_i(WB_WB[1]),
        .data_o(write_back_data)
        );


//branch related setting





endmodule



