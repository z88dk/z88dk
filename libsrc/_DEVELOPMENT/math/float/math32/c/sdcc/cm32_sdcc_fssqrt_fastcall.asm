
; float __fssqrt_fastcall (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fssqrt_fastcall

EXTERN m32_fssqrt_fastcall

    ; square root sdcc float
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC cm32_sdcc_fssqrt_fastcall = m32_fssqrt_fastcall    ; enter DEHL = sdcc_float
                                                        ;
                                                        ; return DEHL = sdcc_float
