module HazardUnit(IDRegRs, IDRegRt, EXRegRt, EXMemRead, PCWrite, IFIDWrite, Flush_con); 

    input [4:0] IDRegRs, IDRegRt, EXRegRt;
    input EXMemRead;  //MEM_EX[1]

    output PCWrite, IFIDWrite, Flush_con;
    reg PCWrite, IFIDWrite, Flush_con;

    always@(IDRegRs,IDRegRt,EXRegRt,EXMemRead) 
    begin
        if( EXMemRead && ((EXRegRt == IDRegRs) | (EXRegRt == IDRegRt)) )
            begin
            //stall 
            PCWrite <= 0; 
            IFIDWrite <= 0; 
            Flush_con <= 1;
            end
        else 
            begin
            //no stall 
            PCWrite <= 1; 
            IFIDWrite <= 1; 
            Flush_con <= 0;
            end
    end 

endmodule