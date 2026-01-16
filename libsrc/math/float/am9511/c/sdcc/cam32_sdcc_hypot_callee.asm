
; float __hypot_callee (float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc_hypot_callee

EXTERN asm_sdcc_readr_callee, asm_am9511_hypot_callee

.cam32_sdcc_hypot_callee

    ; find the hypotenuse of two sdcc floats
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call asm_sdcc_readr_callee
    jp asm_am9511_hypot_callee  ; enter stack = sdcc_float left, ret
                                ;        DEHL = sdcc_float right
                                ; return DEHL = sdcc_float
