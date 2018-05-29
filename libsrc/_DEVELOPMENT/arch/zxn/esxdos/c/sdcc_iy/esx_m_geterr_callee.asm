; void esx_m_geterr(uint16_t error,unsigned char *msg)

SECTION code_esxdos

PUBLIC _esx_m_geterr_callee

EXTERN asm_esx_m_geterr

_esx_m_geterr_callee:

   pop af
   pop de
   pop hl
   push af
   
   jp asm_esx_m_geterr
