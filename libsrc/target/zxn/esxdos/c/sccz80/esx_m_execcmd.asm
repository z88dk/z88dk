; uint16_t esx_m_execcmd(unsigned char *cmdline)

SECTION code_esxdos

PUBLIC esx_m_execcmd

EXTERN asm_esx_m_execcmd

defc esx_m_execcmd = asm_esx_m_execcmd

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_execcmd
defc _esx_m_execcmd = esx_m_execcmd
ENDIF

