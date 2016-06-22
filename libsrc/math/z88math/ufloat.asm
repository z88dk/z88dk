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

                PUBLIC    ufloat
                EXTERN    fa

.ufloat
        push    de      ;msb
        exx
        pop     hl
        ld      c,0     ;no exponent
        ld      a,h
        push    af
        res     7,h
        fpp(FP_FLT)
        pop     af
        rlca
        jr      nc,ufloat_out   ;no high bit
;to multiply by two, increment the exponent
        inc     c
.ufloat_out
        ld      (fa+3),hl
        ld      a,c
        ld      (fa+5),a
        exx
        ld      (fa+1),hl
        xor     a
        ld      (fa),a
        ret
