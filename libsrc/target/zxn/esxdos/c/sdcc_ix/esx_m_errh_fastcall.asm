; void esx_m_errh(void (*handler)(uint8_t error))

SECTION code_esxdos

PUBLIC _esx_m_errh_fastcall

EXTERN asm_esx_m_errh

_esx_m_errh_fastcall:

   push ix
   
   call asm_esx_m_errh

   pop ix
   ret
