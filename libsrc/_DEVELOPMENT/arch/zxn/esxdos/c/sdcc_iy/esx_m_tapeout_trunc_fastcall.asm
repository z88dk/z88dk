; unsigned char esx_m_tapeout_trunc(unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_m_tapeout_trunc_fastcall

EXTERN asm_esx_m_tapeout_trunc

defc _esx_m_tapeout_trunc_fastcall = asm_esx_m_tapeout_trunc
