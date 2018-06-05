; void esx_m_geterr(uint16_t error,unsigned char *msg)

SECTION code_esxdos

PUBLIC esx_m_geterr_callee

EXTERN asm_esx_m_geterr

esx_m_geterr_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm_esx_m_geterr
