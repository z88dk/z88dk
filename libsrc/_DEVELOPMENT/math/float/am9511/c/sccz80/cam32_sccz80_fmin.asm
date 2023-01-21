
; float _fmin (float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_fmin

EXTERN asm_sccz80_read1, asm_sccz80_readl, asm_am9511_compare_sccz80

    ; minimum of two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret
    ;
    ; exit  : stack = sccz80_float left, sccz80_float right, ret
    ;          DEHL = sccz80_float
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cam32_sccz80_fmin
    call asm_am9511_compare_sccz80  ; compare two floats on the stack
    jp C,asm_sccz80_readl
    jp asm_sccz80_read1     ; enter  stack = sccz80_float left, sccz80_float right, ret
                            ; return stack = sccz80_float left, sccz80_float right, ret
                            ;         DEHL = sccz80_float min
