
; float __fssqr (float number)

SECTION code_clib
SECTION code_math

PUBLIC cm32_sdcc_fssqr

EXTERN cm32_sdcc_fsreadl, m32_fssqr_fastcall

.cm32_sdcc_fssqr

    ; square (^2) sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(number^2)
    ;
    ; uses  : af, bc, de, hl, af'

    call cm32_sdcc_fsreadl

    jp m32_fssqr_fastcall   ; enter  DEHL = sdcc_float
                            ;
                            ; return DEHL = sdcc_float
