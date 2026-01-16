

SECTION code_fp_am9511

PUBLIC  cam32_sdcc___fsgt

EXTERN asm_am9511_compare

; Entry: stack: float right, float left, ret
.cam32_sdcc___fsgt
    call asm_am9511_compare
    jr Z,gt1
    ccf
    ret C
.gt1
    dec hl
    ret
