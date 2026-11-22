; void esx_m_geterr(uint16_t error,unsigned char *msg)

SECTION code_esxdos

PUBLIC _esx_m_geterr_callee
PUBLIC l0_esx_m_geterr_callee

EXTERN asm_esx_m_geterr

_esx_m_geterr_callee:

   pop hl
   pop de
   ex (sp),hl

l0_esx_m_geterr_callee:

   push ix
   
   call asm_esx_m_geterr

   pop ix
   ret
