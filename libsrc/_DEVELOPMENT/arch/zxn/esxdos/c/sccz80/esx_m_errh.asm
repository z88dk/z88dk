; void esx_m_errh(void (*handler)(uint8_t error))

SECTION code_esxdos

PUBLIC esx_m_errh

EXTERN asm_esx_m_errh

defc esx_m_errh = asm_esx_m_errh

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_errh
defc _esx_m_errh = esx_m_errh
ENDIF

