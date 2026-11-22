; unsigned char esx_m_tapein_flags(uint8_t flags)

SECTION code_esxdos

PUBLIC esx_m_tapein_flags

EXTERN asm_esx_m_tapein_flags

defc esx_m_tapein_flags = asm_esx_m_tapein_flags

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_tapein_flags
defc _esx_m_tapein_flags = esx_m_tapein_flags
ENDIF

