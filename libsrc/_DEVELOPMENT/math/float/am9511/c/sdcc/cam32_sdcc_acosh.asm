
SECTION code_fp_am9511

PUBLIC cam32_sdcc_acosh

EXTERN cam32_sdcc_read1, _am9511_acosh

.cam32_sdcc_acosh
    call cam32_sdcc_read1
    jp _am9511_acosh
