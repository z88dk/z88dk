;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double cos(double)
;Number in FA..

                INCLUDE  "#fpp.def"

                XLIB    cos

                XREF    fsetup
                XREF    stkequ2

.cos
        call    fsetup
        fpp(FP_COS)
        jp      stkequ2



