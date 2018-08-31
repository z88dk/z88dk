; ulong esxdos_m_getdate(void)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_m_getdate

EXTERN asm_esxdos_m_getdate

defc esxdos_m_getdate = asm_esxdos_m_getdate

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_m_getdate
defc _esxdos_m_getdate = esxdos_m_getdate
ENDIF

