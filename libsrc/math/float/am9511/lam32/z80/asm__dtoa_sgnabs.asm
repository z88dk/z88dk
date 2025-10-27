
SECTION code_clib
SECTION code_fp_am9511

PUBLIC __dtoa_sgnabs

EXTERN asm_am9511__dtoa_sgnabs

    ; enter : x = dehl' = floating point number
    ;
    ; exit  : dehl' = |x|
    ;         a = sgn(x) = 1 if negative, 0 otherwise
    ;
    ; uses  : af


DEFC  __dtoa_sgnabs = asm_am9511__dtoa_sgnabs   ; enter stack  = ret
                                                ;        DEHL' = IEEE-754 float
                                                ; return DEHL' = IEEE-754 float
                                                ;           A  = sign
