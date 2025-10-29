; unsigned char esx_m_tapein_close(void)

SECTION code_esxdos

PUBLIC esx_m_tapein_close

EXTERN asm_esx_m_tapein_close

defc esx_m_tapein_close = asm_esx_m_tapein_close

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_tapein_close
defc _esx_m_tapein_close = esx_m_tapein_close
ENDIF

