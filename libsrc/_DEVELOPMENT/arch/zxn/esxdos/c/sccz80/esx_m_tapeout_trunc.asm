; unsigned char esx_m_tapeout_trunc(unsigned char *filename)

SECTION code_esxdos

PUBLIC esx_m_tapeout_trunc

EXTERN asm_esx_m_tapeout_trunc

defc esx_m_tapeout_trunc = asm_esx_m_tapeout_trunc
