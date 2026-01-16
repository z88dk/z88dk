; unsigned char esx_m_tapein_setpos(uint16_t block)

SECTION code_esxdos

PUBLIC esx_m_tapein_setpos

EXTERN asm_esx_m_tapein_setpos

defc esx_m_tapein_setpos = asm_esx_m_tapein_setpos

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_tapein_setpos
defc _esx_m_tapein_setpos = esx_m_tapein_setpos
ENDIF

