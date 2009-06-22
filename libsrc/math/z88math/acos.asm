;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double acos(double)
;Number in FA..

                INCLUDE  "fpp.def"

                XLIB    acos

                LIB	fsetup
                LIb	stkequ2

.acos
        call    fsetup
        fpp(FP_ACS)
        jp      stkequ2



