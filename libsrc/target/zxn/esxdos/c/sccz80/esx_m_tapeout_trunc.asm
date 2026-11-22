; unsigned char esx_m_tapeout_trunc(unsigned char *filename)

SECTION code_esxdos

PUBLIC esx_m_tapeout_trunc

EXTERN asm_esx_m_tapeout_trunc

defc esx_m_tapeout_trunc = asm_esx_m_tapeout_trunc

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_tapeout_trunc
defc _esx_m_tapeout_trunc = esx_m_tapeout_trunc
ENDIF

