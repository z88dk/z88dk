; unsigned char esx_m_tapein_toggle_pause(void)

SECTION code_esxdos

PUBLIC esx_m_tapein_toggle_pause

EXTERN asm_esx_m_tapein_toggle_pause

defc esx_m_tapein_toggle_pause = asm_esx_m_tapein_toggle_pause

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_tapein_toggle_pause
defc _esx_m_tapein_toggle_pause = esx_m_tapein_toggle_pause
ENDIF

