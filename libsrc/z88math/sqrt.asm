;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double sqrt(double)  
;Number in FA..

                INCLUDE  "#fpp.def"

                XLIB    sqrt

                LIB	fsetup
                LIB	stkequ2

.sqrt
        call    fsetup
        fpp(FP_SQR)
        jp      stkequ2



