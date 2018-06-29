; unsigned char esx_m_setcaps(unsigned char caps)

SECTION code_esxdos

PUBLIC _esx_m_setcaps_fastcall

EXTERN asm_esx_m_setcaps

defc _esx_m_setcaps_fastcall = asm_esx_m_setcaps
