

SECTION code_fp_am9511

PUBLIC  cam32_sdcc___fseq

EXTERN asm_am9511_compare

; Entry: stack: float right, float left, ret
.cam32_sdcc___fseq
    call asm_am9511_compare
    scf
    ret Z
    ccf
    dec hl
    ret
