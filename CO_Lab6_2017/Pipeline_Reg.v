module IFID(clk_i, rst_n, IFIDWrite, flush, PC_Plus4, Inst, InstReg, PC_Plus4Reg);
    
    input clk_i,rst_n;
    input [31:0] PC_Plus4,Inst;
    input IFIDWrite,flush;

    output [31:0] InstReg, PC_Plus4Reg;
    reg [31:0] InstReg, PC_Plus4Reg;


    always@(posedge clk_i or posedge rst_n)
    begin
        if(rst_n == 0 || flush)
        begin
            InstReg <= 0;
            PC_Plus4Reg <=0;
        end
        else if(IFIDWrite)
        begin
            InstReg <= Inst;
            PC_Plus4Reg <= PC_Plus4;
        end
    end

endmodule


module IDEX(clk_i, rst_n, WB, M ,EX , DataA , DataB, imm_value, zero_value, Shifter, RegRs, RegRt, RegRd, func_i,  WBreg, Mreg, EXreg, DataAreg, DataBreg, imm_valuereg, zero_valuereg, Shifterreg, RegRsreg, RegRtreg, RegRdreg, func_ireg);

    input clk_i, rst_n;
    input [1:0] WB;
    input [1:0] M;
    input [4:0] EX;
    input [31:0] DataA,DataB,imm_value,zero_value;
    input [4:0] Shifter;
    input [4:0] RegRt,RegRd,RegRs;
    input [5:0] func_i;
    
    output [1:0] WBreg;
    output [1:0] Mreg;
    output [4:0] EXreg;
    output [31:0] DataAreg,DataBreg,imm_valuereg,zero_valuereg;
    output [4:0] Shifterreg;
    output [4:0] RegRtreg,RegRdreg,RegRsreg;
    output [5:0] func_ireg;
    
    reg [1:0] WBreg;
    reg [1:0] Mreg;
    reg [4:0] EXreg;
    reg [31:0] DataAreg,DataBreg,imm_valuereg,zero_valuereg;
    reg [4:0] Shifterreg;
    reg [4:0] RegRtreg,RegRdreg,RegRsreg;
    reg [5:0] func_ireg;
 
    always@(posedge clk_i or posedge rst_n)
    begin
        if(rst_n == 0) 
        begin
            WBreg <= 0;
            Mreg <= 0;
            EXreg <= 0;
            DataAreg <= 0;
            DataBreg <= 0;
            imm_valuereg <= 0;
            zero_valuereg <= 0;
            Shifterreg <= 0;
            RegRtreg <= 0;
            RegRdreg <= 0;
            RegRsreg <= 0;
            func_ireg <= 0;
        end
        else
        begin
            WBreg <= WB;
            Mreg <= M;
            EXreg <= EX;
            DataAreg <= DataA;
            DataBreg <= DataB;
            imm_valuereg <= imm_value;
            zero_valuereg <= zero_value;
            Shifterreg <= Shifter;
            RegRtreg <= RegRt;
            RegRdreg <= RegRd;
            RegRsreg <= RegRs;
            func_ireg <= func_i;
        end
    end
    
endmodule

module EXMEM(clk_i, rst_n , WB, M, ALUOut, RegRD, Mem_WriteData,  WBreg, Mreg, ALUreg, RegRDreg, Mem_WriteDatareg);

   input clk_i, rst_n;
   input [1:0] WB;
   input [1:0] M;
   input [4:0] RegRD;
   input [31:0] ALUOut, Mem_WriteData;

   output [1:0] WBreg;
   output [1:0] Mreg;
   output [4:0] RegRDreg;
   output [31:0] ALUreg,Mem_WriteDatareg;
   

   reg [1:0] WBreg;
   reg [1:0] Mreg;
   reg [4:0] RegRDreg;
   reg [31:0] ALUreg,Mem_WriteDatareg;


    always@(posedge clk_i or posedge rst_n)
    begin
        if(rst_n == 0) 
        begin
            WBreg <= 0;
            Mreg <= 0;
            ALUreg <= 0;
            Mem_WriteDatareg <= 0;
            RegRDreg <= 0;
        end
        else
        begin
            WBreg <= WB;
            Mreg <= M;
            ALUreg <= ALUOut;
            Mem_WriteDatareg <= Mem_WriteData;
            RegRDreg <= RegRD;
        end
    end

endmodule


module MEMWB(clk_i, rst_n, WB, Memout, ALUOut, RegRD,  WBreg, Memreg, ALUreg, RegRDreg);

   input clk_i, rst_n;
   input [1:0] WB;
   input [4:0] RegRD;
   input [31:0] Memout,ALUOut;

   output [1:0] WBreg;
   output [4:0] RegRDreg;
   output [31:0] Memreg,ALUreg;

   reg [1:0] WBreg;
   reg [4:0] RegRDreg;
   reg [31:0] Memreg,ALUreg;
   

    always@(posedge clk_i or posedge rst_n)
    begin
        if(rst_n == 0) 
        begin
            WBreg <= 0;
            Memreg <= 0;
            ALUreg <= 0;
            RegRDreg <= 0;
        end
        else
        begin
            WBreg <= WB;
            Memreg <= Memout;
            ALUreg <= ALUOut;
            RegRDreg <= RegRD;
        end
    end
endmodule