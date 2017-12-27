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
wire PC_Write;
wire IFID_Write;
wire IFIDreg_flush;

/**** ID stage ****/

//control signal
wire Flush_control;
wire [4:0] EX_ID;
wire [1:0] MEM_ID;
wire [1:0] WB_ID;
wire RegDst;
wire ALUSrc;
wire [2:0] ALUOp;
assign EX_ID = Flush_control? 0 : {RegDst, ALUSrc, ALUOp};
//2:0 ALUOp
//3 ALUSrc
//4 RegDst
wire MemRead;
wire MemWrite;
assign MEM_ID = Flush_control? 0 : {MemRead, MemWrite};
wire MemtoReg;
wire RegWrite;
assign WB_ID = Flush_control? 0 : {MemtoReg, RegWrite};
wire Jump_sel;

wire [31:0] instr_ID;
wire [31:0] pc_add_ID;
wire [31:0] RSdata;     //RS output
wire [31:0] RTdata;     //RT output   
//wire [4:0] RDdata;      //RD input position
wire [31:0] sign_ext;
wire [31:0] zero_fill;  //furslt 2
wire Branch_type_select;
wire Branch;
wire [31:0] branch_pc;
wire [31:0] after_branch_new_pc;
wire PCSrc;
/**** EX stage ****/

//control signal
wire [1:0] WB_EX;
wire [1:0] MEM_EX;
wire [4:0] EX_EX;
wire [31:0] RSdata_EX;
wire [31:0] RTdata_EX;
wire [31:0] imm_value_EX;
wire [31:0] zero_value_EX;
wire [4:0] Shifter_srll_EX;
wire [4:0] RegRt_EX;
wire [4:0] RegRd_EX;
wire [4:0] RegRs_EX;
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
wire overflow;
wire zero;
wire [31:0] Mem_wirteback_data;

wire [1:0] ForA_sel;
wire [1:0] ForB_sel;
wire [31:0] ALU_srcA;
wire [31:0] ALU_srcB;

/**** MEM stage ****/

//control signal
wire [1:0] WB_MEM;
wire [1:0] MEM_MEM;
wire [31:0] ALU_MEM;
wire [4:0] RegRd_MEM;
wire [31:0] Mem_WriteData;

wire [31:0] Mem_data_o;


/**** WB stage ****/

//control signal
wire [31:0] write_back_data;

wire [1:0] WB_WB;
wire [31:0] Memdata_WB;
wire [31:0] ALUdata_WB;
wire [4:0] RegRd_WB;  //write back to RF


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage

assign PCSrc = (Branch) && ((RSdata == RTdata) && (Branch_type_select == 0))| ((RSdata != RTdata) && (Branch_type_select == 1));
assign IFIDreg_flush = Jump_sel | PCSrc;

Mux2to1 #(.size(32)) Branch_choose(
        .data0_i(pc_add),
        .data1_i(branch_pc),
        .select_i(PCSrc),
        .data_o(after_branch_new_pc)
        ); 

Mux2to1 #(.size(32)) Jump_choose(
        .data0_i(after_branch_new_pc),
        .data1_i({pc_add[31:28], instr_ID[25:0], 2'b00}),
        .select_i(Jump_sel),
        .data_o(pc_final)
        );

Program_Counter PC(
            .clk_i(clk_i),      
	    .rst_n(rst_n),
            .PCWrite(PC_Write),     
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
            .IFIDWrite(IFID_Write),
            .flush(IFIDreg_flush), 
            .PC_Plus4(pc_add), 
            .Inst(instr),
            .InstReg(instr_ID), 
            .PC_Plus4Reg(pc_add_ID)
            );

//Instantiate the components in ID stage

HazardUnit Hazard(
        .IDRegRs(instr_ID[25:21]), 
        .IDRegRt(instr_ID[20:16]), 
        .EXRegRt(RegRt_EX), 
        .EXMemRead(MEM_EX[1]), 
        .PCWrite(PC_Write), 
        .IFIDWrite(IFID_Write), 
        .Flush_con(Flush_control)  //control EX_ID MEM_ID WB_ID
        );


Reg_File RF(
        .clk_i(clk_i),      
	.rst_n(rst_n) ,     
        .RSaddr_i(instr_ID[25:21]) ,  
        .RTaddr_i(instr_ID[20:16]) ,  
        .Wrtaddr_i(RegRd_WB),  
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
        .Jump_o(Jump_sel),
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


Adder Adder_for_branch(
        .src1_i(pc_add_ID),     
        .src2_i(sign_ext << 2),
        .sum_o(branch_pc)    
        );

IDEX IDEXreg(
        .clk_i(clk_i), 
        .rst_n(rst_n),
        .WB(WB_ID),
        .M(MEM_ID),
        .EX(EX_ID),
        .DataA(RSdata), 
        .DataB(RTdata), 
        .imm_value(sign_ext), 
        .zero_value(zero_fill), 
        .Shifter(instr_ID[10:6]), //FOR SRL SLL
        .RegRs(instr_ID[25:21]),
        .RegRt(instr_ID[20:16]),
        .RegRd(instr_ID[15:11]),
        .func_i(instr_ID[5:0]),
        .WBreg(WB_EX), 
        .Mreg(MEM_EX), 
        .EXreg(EX_EX), 
        .DataAreg(RSdata_EX), 
        .DataBreg(RTdata_EX), 
        .imm_valuereg(imm_value_EX), 
        .zero_valuereg(zero_value_EX), 
        .Shifterreg(Shifter_srll_EX),
        .RegRsreg(RegRs_EX), 
        .RegRtreg(RegRt_EX), 
        .RegRdreg(RegRd_EX),
        .func_ireg(func_i_EX)
        );

//Instantiate the components in EX stage

ForwardUnit ForwardHazard(
        .EXRegRs(RegRs_EX), 
        .EXRegRt(RegRt_EX), 
        .MEMRegRd(RegRd_MEM),
        .WBRegRd(RegRd_WB), 
        .MEM_RegWrite(WB_MEM[0]), 
        .WB_RegWrite(WB_WB[0]), 
        .ForwardA(ForA_sel), 
        .ForwardB(ForB_sel)
        );

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(RegRt_EX),
        .data1_i(RegRd_EX),
        .select_i(EX_EX[4]),
        .data_o(RDdata_EX)
        );

ALU_Ctrl AC(
        .funct_i(func_i_EX),   
        .ALUOp_i(EX_EX[2:0]),   
        .ALU_operation_o(ALU_operation),
	.FURslt_o(FURslt),
        .sr_sl_o(leftRight_sel),
        .Slv_o(Shifter_shamt_sel)
        );

Mux3to1 #(.size(32)) ALU_src1(
        .data0_i(RSdata_EX),
        .data1_i(ALU_MEM),
        .data2_i(write_back_data),
        .select_i(ForA_sel),
        .data_o(ALU_srcA)
        );

Mux3to1 #(.size(32)) to_ALU_src2(
        .data0_i(RTdata_EX),
        .data1_i(ALU_MEM),
        .data2_i(write_back_data),
        .select_i(ForB_sel),
        .data_o(to_aluSrc2)
        );

Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(to_aluSrc2),
        .data1_i(imm_value_EX),
        .select_i(EX_EX[3]),
        .data_o(ALU_srcB)
        );

ALU ALU(
	.aluSrc1(ALU_srcA),
	.aluSrc2(ALU_srcB),
	.ALU_operation_i(ALU_operation),
	.result(ALU_result),
	.zero(zero),
	.overflow(overflow)
	);

/*
Mux3to1 #(.size(1)) Branch_type_mux(
        .data0_i(zero),
        .data1_i(~zero),
	.data2_i(~ALU_result[31]),
        .select_i(EX_EX[1:0]), //Branch_type_select
        .data_o(Branch_type)
        );
*/

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
        .ALUOut(Mem_wirteback_data), 
        .RegRD(RDdata_EX), 
        .Mem_WriteData(RTdata_EX),
        .WBreg(WB_MEM), 
        .Mreg(MEM_MEM), 
        .ALUreg(ALU_MEM), 
        .RegRDreg(RegRd_MEM), 
        .Mem_WriteDatareg(Mem_WriteData)
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

MEMWB MEMWBreg(
        .clk_i(clk_i), 
        .rst_n(rst_n), 
        .WB(WB_MEM), 
        .Memout(Mem_data_o), 
        .ALUOut(ALU_MEM), 
        .RegRD(RegRd_MEM),  
        .WBreg(WB_WB), 
        .Memreg(Memdata_WB), 
        .ALUreg(ALUdata_WB), 
        .RegRDreg(RegRd_WB)
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



