; uint16_t esx_m_dosversion(void)

SECTION code_esxdos

PUBLIC esx_m_dosversion

EXTERN asm_esx_m_dosversion

defc esx_m_dosversion = asm_esx_m_dosversion

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_dosversion
defc _esx_m_dosversion = esx_m_dosversion
ENDIF

