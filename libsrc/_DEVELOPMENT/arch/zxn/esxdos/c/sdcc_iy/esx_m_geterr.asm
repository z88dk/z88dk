; void esx_m_geterr(uint16_t error,unsigned char *msg)

SECTION code_esxdos

PUBLIC _esx_m_geterr

EXTERN asm_esx_m_geterr

_esx_m_geterr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_esx_m_geterr
