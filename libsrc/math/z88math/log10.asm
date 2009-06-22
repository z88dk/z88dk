;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double log10(double)  
;Number in FA..

                INCLUDE  "fpp.def"

                XLIB    log10

                LIB	fsetup
                LIB	stkequ2

.log10
        call    fsetup
        fpp(FP_LOG)
        jp      stkequ2



