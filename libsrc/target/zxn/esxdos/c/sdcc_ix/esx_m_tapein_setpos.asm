; unsigned char esx_m_tapein_setpos(uint16_t block)

SECTION code_esxdos

PUBLIC _esx_m_tapein_setpos

EXTERN asm_esx_m_tapein_setpos

_esx_m_tapein_setpos:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_m_tapein_setpos
