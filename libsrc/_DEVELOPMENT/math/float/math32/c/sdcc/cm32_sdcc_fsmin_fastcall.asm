
; float __fsmin_fastcall (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fsmin_fastcall

EXTERN m32_fsmin_fastcall

    ; change underflow to a error floating zero as sdcc float
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(0)
    ;
    ; uses  : af, bc, de, hl

DEFC cm32_sdcc_fsmin_fastcall = m32_fsmin_fastcall  ; enter DEHL = sdcc_float
                                                    ;
                                                    ; return DEHL = sdcc_float
