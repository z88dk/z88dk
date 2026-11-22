; unsigned char esx_m_setcaps(unsigned char caps)

SECTION code_esxdos

PUBLIC esx_m_setcaps

EXTERN asm_esx_m_setcaps

defc esx_m_setcaps = asm_esx_m_setcaps

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_setcaps
defc _esx_m_setcaps = esx_m_setcaps
ENDIF

