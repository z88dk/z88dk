
; float __fsneg_fastcall (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fsneg_fastcall

EXTERN m32_fsneg_fastcall

    ; negate sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(-number)
    ;
    ; uses  : af, bc, de, hl

DEFC cm32_sdcc_fsneg_fastcall = m32_fsneg_fastcall  ; enter DEHL = sdcc_float
                                                    ;
                                                    ; return DEHL = sdcc_float
