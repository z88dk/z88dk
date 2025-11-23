; uint16_t esx_m_dosversion(void)

SECTION code_esxdos

PUBLIC _esx_m_dosversion

EXTERN asm_esx_m_dosversion

defc _esx_m_dosversion = asm_esx_m_dosversion
