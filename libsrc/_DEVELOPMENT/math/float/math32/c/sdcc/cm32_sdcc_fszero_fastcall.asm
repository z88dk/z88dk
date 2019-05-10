
; float __fszero_fastcall (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fszero_fastcall

EXTERN m32_fszero_fastcall

    ; return a legal zero
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(0)
    ;
    ; uses  : af, bc, de, hl

DEFC cm32_sdcc_fszero_fastcall = m32_fszero_fastcall    ; enter DEHL = sdcc_float
                                                        ;
                                                        ; return DEHL = sdcc_float
