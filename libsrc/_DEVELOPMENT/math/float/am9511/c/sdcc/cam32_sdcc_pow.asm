

SECTION code_fp_am9511
PUBLIC cam32_sdcc_pow

EXTERN cam32_sdcc_readr
EXTERN asm_am9511_pow

.cam32_sdcc_pow
    call cam32_sdcc_readr
    jp asm_am9511_pow
