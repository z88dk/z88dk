
; float __fsinv_fastcall (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fsinv_fastcall

EXTERN m32_fsinv_fastcall

    ; invert sdcc float
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(1/number)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

DEFC cm32_sdcc_fsinv_fastcall =  m32_fsinv_fastcall     ; enter  DEHL = sdcc_float
                                                        ;
                                                        ; return DEHL = sdcc_float
