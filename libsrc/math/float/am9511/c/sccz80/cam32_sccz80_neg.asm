

SECTION code_fp_am9511
PUBLIC cam32_sccz80_neg

EXTERN asm_sccz80_read1, asm_am9511_neg

    ; negate sccz80 floats
    ;
    ; enter : stack = sccz80_float number, ret
    ;
    ; exit  :  DEHL = sccz80_float(-number)
    ;
    ; uses  : af, bc, de, hl

.cam32_sccz80_neg
    call asm_sccz80_read1
    jp asm_am9511_neg
