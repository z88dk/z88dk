
SECTION code_fp_am9511

PUBLIC cam32_sdcc_ceil

EXTERN cam32_sdcc_read1, asm_am9511_ceil_fastcall

.cam32_sdcc_ceil
    call cam32_sdcc_read1
    jp asm_am9511_ceil_fastcall
