;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double log10(double)    
;Number in FA..

                INCLUDE  "#fpp.def"

                XLIB    exp

                XREF    fsetup
                XREF    stkequ2

.exp
        call    fsetup
        fpp(FP_EXP)
        jp      stkequ2



