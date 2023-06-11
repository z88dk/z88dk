
; float _fmin (float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sccz80_fmin

IFDEF __CPU_8085__

EXTERN _am9511_fmin
defc cam32_sccz80_fmin = _am9511_fmin

ELSE

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
    jp C,left
    call  asm_sccz80_read1  ; enter  stack = sccz80_float left, sccz80_float right, ret
    ret                     ; return stack = sccz80_float left, sccz80_float right, ret
                            ;         DEHL = sccz80_float min

.left
    call asm_sccz80_readl
    ret

ENDIF
