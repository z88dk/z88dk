; uchar esxdos_m_gethandle(void)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_m_gethandle

EXTERN asm_esxdos_m_gethandle

defc esxdos_m_gethandle = asm_esxdos_m_gethandle

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_m_gethandle
defc _esxdos_m_gethandle = esxdos_m_gethandle
ENDIF

