; void esx_m_errh(void (*handler)(uint8_t error))

SECTION code_esxdos

PUBLIC _esx_m_errh

EXTERN _esx_m_errh_fastcall

_esx_m_errh:

   pop af
   pop hl
   
   push hl
   push af

   jp _esx_m_errh_fastcall
