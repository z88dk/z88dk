;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double log(double)     - natural log
;Number in FA..


                INCLUDE  "fpp.def"

                XLIB    log

                LIB	fsetup
                LIB	stkequ2

.log
        call    fsetup
        fpp(FP_LN)
        jp      stkequ2



