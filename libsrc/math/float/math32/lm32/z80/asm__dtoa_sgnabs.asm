
SECTION code_clib
SECTION code_fp_math32

PUBLIC __dtoa_sgnabs

EXTERN m32__dtoa_sgnabs

    ; enter : x = dehl' = floating point number
    ;
    ; exit  : dehl' = |x|
    ;         a = sgn(x) = 1 if negative, 0 otherwise
    ;
    ; uses  : af


DEFC  __dtoa_sgnabs = m32__dtoa_sgnabs          ; enter stack  = ret
                                                ;        DEHL' = d32_float
                                                ; return DEHL'  = d32_float
                                                ;           A  = sign
