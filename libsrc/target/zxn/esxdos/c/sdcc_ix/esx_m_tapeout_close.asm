; unsigned char esx_m_tapeout_close(void)

SECTION code_esxdos

PUBLIC _esx_m_tapeout_close

EXTERN asm_esx_m_tapeout_close

defc _esx_m_tapeout_close = asm_esx_m_tapeout_close
