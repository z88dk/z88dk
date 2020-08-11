
SECTION code_fp_am9511

PUBLIC cam32_sdcc_tanh

EXTERN cam32_sdcc_read1, _am9511_tanh

.cam32_sdcc_tanh
    call cam32_sdcc_read1
    jp _am9511_tanh
