

SECTION code_fp_am9511

PUBLIC  cam32_sdcc___fsneq

EXTERN asm_am9511_compare

; Entry: stack: float right, float left, ret
cam32_sdcc___fsneq:
    call asm_am9511_compare
    scf
    ret NZ
    ccf
    dec hl
    ret
