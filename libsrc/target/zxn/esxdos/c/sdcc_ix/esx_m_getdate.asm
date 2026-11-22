; unsigned char esx_m_getdate(struct dos_tm *)

SECTION code_esxdos

PUBLIC _esx_m_getdate

EXTERN asm_esx_m_getdate

_esx_m_getdate:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_m_getdate
