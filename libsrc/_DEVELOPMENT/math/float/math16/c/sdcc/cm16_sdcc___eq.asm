
SECTION code_fp_math16

PUBLIC  cm16_sdcc___eq

EXTERN cm16_sdcc_readr
EXTERN asm_f16_compare

; Entry: stack: half right, half left, ret
.cm16_sdcc___eq
    call asm_f16_compare
    scf
    ret Z
    ccf
    dec hl
    ret

