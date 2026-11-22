; unsigned char esx_m_tapein_open(unsigned char *filename)

SECTION code_esxdos

PUBLIC esx_m_tapein_open

EXTERN asm_esx_m_tapein_open

defc esx_m_tapein_open = asm_esx_m_tapein_open

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_tapein_open
defc _esx_m_tapein_open = esx_m_tapein_open
ENDIF

