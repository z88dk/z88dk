
; float __fsub_callee (float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC _am9511_fsub_callee
PUBLIC cam32_sdcc_fsub_callee

EXTERN asm_sdcc_readr_callee, asm_am9511_fsub_callee

DEFC _am9511_fsub_callee = cam32_sdcc_fsub_callee

.cam32_sdcc_fsub_callee

    ; subtract sdcc float from sdcc float
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left-right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call asm_sdcc_readr_callee
    jp asm_am9511_fsub_callee   ; enter stack = sdcc_float left, ret
                                ;        DEHL = sdcc_float right
                                ; return DEHL = sdcc_float
