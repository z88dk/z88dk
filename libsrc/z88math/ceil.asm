;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double ceil(double)  
;Number in FA..
;
;This is implemented as  -(floor(-x))

                INCLUDE  "#fpp.def"

                XLIB    ceil

                LIB	fsetup
                LIB	stkequ2

.ceil
        call    fsetup
        fpp(FP_NEG)
        fpp(FP_INT)             ;floor it (round down!)
        fpp(FP_NEG)
        jp      stkequ2



