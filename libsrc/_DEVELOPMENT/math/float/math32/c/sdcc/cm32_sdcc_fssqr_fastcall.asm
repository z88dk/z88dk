
; float __fssqr_fastcall (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sdcc_fssqr_fastcall

EXTERN m32_fssqr_fastcall

    ; square (^2) sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(number^2)
    ;
    ; uses  : af, bc, de, hl, af'

DEFC cm32_sdcc_fssqr_fastcall =  m32_fssqr_fastcall     ; enter  DEHL = sdcc_float
                                                        ;
                                                        ; return DEHL = sdcc_float
