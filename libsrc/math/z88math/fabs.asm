;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double fabs(double)  
;Number in FA..

		INCLUDE "#fpp.def"


                XLIB    fabs

                LIB	fsetup
                LIB	stkequ2

.fabs
        call    fsetup
        fpp(FP_ABS)
        jp      stkequ2



