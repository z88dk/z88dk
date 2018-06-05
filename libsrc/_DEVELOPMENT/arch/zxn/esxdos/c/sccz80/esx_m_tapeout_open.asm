; unsigned char esx_m_tapeout_open(unsigned char *appendname)

SECTION code_esxdos

PUBLIC esx_m_tapeout_open

EXTERN asm_esx_m_tapeout_open

defc esx_m_tapeout_open = asm_esx_m_tapeout_open
