; void esx_m_errh(void (*handler)(uint8_t error))

SECTION code_esxdos

PUBLIC _esx_m_errh

EXTERN asm_esx_m_errh

_esx_m_errh:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_m_errh
