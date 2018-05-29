; unsigned char esx_m_tapein_open(unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_m_tapein_open_fastcall

EXTERN asm_esx_m_tapein_open

defc _esx_m_tapein_open_fastcall = asm_esx_m_tapein_open
