; unsigned char esx_m_drvapi(struct esx_drvapi *)

SECTION code_esxdos

PUBLIC _esx_m_drvapi

EXTERN asm_esx_m_drvapi

_esx_m_drvapi:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_m_drvapi
