; unsigned char esx_m_tapeout_open(unsigned char *appendname)

SECTION code_esxdos

PUBLIC esx_m_tapeout_open

EXTERN asm_esx_m_tapeout_open

defc esx_m_tapeout_open = asm_esx_m_tapeout_open

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_tapeout_open
defc _esx_m_tapeout_open = esx_m_tapeout_open
ENDIF

