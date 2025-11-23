; uint16_t esx_m_execcmd(unsigned char *cmdline)

SECTION code_esxdos

PUBLIC _esx_m_execcmd

EXTERN asm_esx_m_execcmd

_esx_m_execcmd:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_m_execcmd
