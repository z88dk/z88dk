;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double sin(double)
;Number in FA..

                INCLUDE  "#fpp.def"

                XLIB    sin

                XREF    fsetup
                XREF    stkequ2

.sin
        call    fsetup
        fpp(FP_SIN)
        jp      stkequ2



