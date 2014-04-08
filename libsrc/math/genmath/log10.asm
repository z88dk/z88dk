;       Small C+ Math Library


                XLIB    log10

                LIB     log
                LIB     fmul



;
.log10  CALL    log    
        LD      BC,$7F5E        ; 1/ln(10)
        LD      IX,$5BD8
        LD      DE,$A938
        JP      fmul    
