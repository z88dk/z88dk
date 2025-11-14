; unsigned char esx_m_tapein_flags(uint8_t flags)

SECTION code_esxdos

PUBLIC _esx_m_tapein_flags

EXTERN asm_esx_m_tapein_flags

_esx_m_tapein_flags:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_m_tapein_flags
