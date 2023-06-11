
; float __fmul(float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_fmul

EXTERN asm_switch_arg, asm_sccz80_readl
EXTERN asm_am9511_fmul

    ; multiply two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret
    ;
    ; exit  :  DEHL = sccz80_float(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cam32_sccz80_fmul
    call asm_switch_arg
    call asm_sccz80_readl
    jp asm_am9511_fmul      ; enter stack = sccz80_float right, sccz80_float left, ret
                            ;        DEHL = sccz80_float right
                            ; return DEHL = sccz80_float
