; unsigned char esx_m_setdrv(unsigned char drive)

SECTION code_esxdos

PUBLIC _esx_m_setdrv

EXTERN asm_esx_m_setdrv

_esx_m_setdrv:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_m_setdrv
