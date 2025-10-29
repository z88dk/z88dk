; unsigned char esx_m_setcaps(unsigned char caps)

SECTION code_esxdos

PUBLIC _esx_m_setcaps

EXTERN asm_esx_m_setcaps

_esx_m_setcaps:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_m_setcaps
