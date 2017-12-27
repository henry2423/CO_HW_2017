module ForwardUnit(EXRegRs, EXRegRt, MEMRegRd, WBRegRd, MEM_RegWrite, WB_RegWrite, ForwardA, ForwardB);


    input[4:0] EXRegRs, EXRegRt, MEMRegRd, WBRegRd;
    input MEM_RegWrite, WB_RegWrite;  //WB_MEM[0] WB_WB[0]
    
    output[1:0] ForwardA, ForwardB;
    reg[1:0] ForwardA, ForwardB;

    //Forward A
    always@(MEM_RegWrite or MEMRegRd or EXRegRs or WB_RegWrite or WBRegRd) 
    begin
        if((MEM_RegWrite) && (MEMRegRd != 0) && (MEMRegRd == EXRegRs)) 
            ForwardA = 2'b01;
        else if((WB_RegWrite) && (WBRegRd != 0) && (WBRegRd == EXRegRs) && (MEMRegRd != EXRegRs)) 
            ForwardA = 2'b10;
        else
            ForwardA = 2'b00;
    end

    //Forward B
    always@(WB_RegWrite or WBRegRd or EXRegRt or MEMRegRd or MEM_RegWrite) 
    begin
        if((MEM_RegWrite) && (MEMRegRd != 0) && (MEMRegRd == EXRegRt)) 
            ForwardB = 2'b01;
        else if((WB_RegWrite) && (WBRegRd != 0) && (WBRegRd == EXRegRt) && (MEMRegRd != EXRegRt))
            ForwardB = 2'b10;
        else
            ForwardB = 2'b00;
    end


endmodule
