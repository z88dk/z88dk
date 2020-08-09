
SECTION code_fp_am9511

PUBLIC cam32_sdcc_atanh

EXTERN cam32_sdcc_read1, _am9511_atanh

.cam32_sdcc_atanh
    call cam32_sdcc_read1
    jp _am9511_atanh
