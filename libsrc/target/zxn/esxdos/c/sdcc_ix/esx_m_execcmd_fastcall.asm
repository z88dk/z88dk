; uint16_t esx_m_execcmd(unsigned char *cmdline)

SECTION code_esxdos

PUBLIC _esx_m_execcmd_fastcall

EXTERN asm_esx_m_execcmd

defc _esx_m_execcmd_fastcall = asm_esx_m_execcmd
