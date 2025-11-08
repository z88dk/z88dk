; unsigned char esx_m_tapeout_close(void)

SECTION code_esxdos

PUBLIC esx_m_tapeout_close

EXTERN asm_esx_m_tapeout_close

defc esx_m_tapeout_close = asm_esx_m_tapeout_close

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_tapeout_close
defc _esx_m_tapeout_close = esx_m_tapeout_close
ENDIF

