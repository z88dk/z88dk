; void esx_m_errh(void (*handler)(uint8_t error))

SECTION code_esxdos

PUBLIC _esx_m_errh_fastcall

EXTERN asm_esx_m_errh

defc _esx_m_errh_fastcall = asm_esx_m_errh
