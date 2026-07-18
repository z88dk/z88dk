
SECTION code_clib
SECTION code_fp_math32

PUBLIC m32__dtoa_sgnabs

    ; enter : dehl' = x = floating point number
    ;
    ; exit  : dehl' = |x|
    ;         a  = sgn(x) = 1 if negative, 0 otherwise
    ;
    ; uses  : af

.m32__dtoa_sgnabs
    exx
    ld a,d
    res 7,d

    exx
    rlca
    and $01
    ret

