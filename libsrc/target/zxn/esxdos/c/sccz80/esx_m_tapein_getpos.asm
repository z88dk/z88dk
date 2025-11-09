; uint16_t esx_m_tapein_getpos(void)

SECTION code_esxdos

PUBLIC esx_m_tapein_getpos

EXTERN asm_esx_m_tapein_getpos

defc esx_m_tapein_getpos = asm_esx_m_tapein_getpos

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_tapein_getpos
defc _esx_m_tapein_getpos = esx_m_tapein_getpos
ENDIF

