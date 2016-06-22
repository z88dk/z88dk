;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm



;Convert from integer to FP..
;We could enter in here with a long in dehl, so, mod to compiler I think!

                SECTION  code_fp
                INCLUDE  "fpp.def"

                PUBLIC    qfloat
		EXTERN	fa

.qfloat
        push    de      ;msb
        exx
        pop     hl
        ld      c,0     ;no exponent
        fpp(FP_FLT)
        ld      (fa+3),hl
        ld      a,c
        ld      (fa+5),a
        exx
        ld      (fa+1),hl
        xor     a
        ld      (fa),a
        ret
