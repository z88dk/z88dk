

SECTION code_fp_am9511

PUBLIC  cam32_sdcc___fslt

EXTERN asm_am9511_compare

; Entry: stack: float right, float left, ret
.cam32_sdcc___fslt
    call asm_am9511_compare
    ret C
    dec hl
    ret
