;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double asin(double)
;Number in FA..

                INCLUDE  "fpp.def"

                XLIB    atan

                LIB	fsetup
                LIB	stkequ2

.atan
        call    fsetup
        fpp(FP_ATN)
        jp      stkequ2



