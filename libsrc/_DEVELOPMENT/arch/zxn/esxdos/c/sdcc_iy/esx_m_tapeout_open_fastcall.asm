; unsigned char esx_m_tapeout_open(unsigned char *appendname)

SECTION code_esxdos

PUBLIC _esx_m_tapeout_open_fastcall

EXTERN asm_esx_m_tapeout_open

defc _esx_m_tapeout_open_fastcall = asm_esx_m_tapeout_open
