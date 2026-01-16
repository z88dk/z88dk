
SECTION code_fp_math16

PUBLIC  cm16_sdcc___gt

EXTERN cm16_sdcc_readr
EXTERN asm_f16_compare

; Entry: stack: half right, half left, ret
.cm16_sdcc___gt
    call asm_f16_compare
    jr Z,gt1
    ccf
    ret C
.gt1
    dec hl
    ret

