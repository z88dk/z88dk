;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;minusfa(double)  (internal function, negate number in FA)
;Number in FA..

                INCLUDE  "fpp.def"

                XLIB    minusfa

                LIB	fsetup
                LIB	stkequ2

.minusfa
        call    fsetup
        fpp(FP_NEG)
        jp      stkequ2



