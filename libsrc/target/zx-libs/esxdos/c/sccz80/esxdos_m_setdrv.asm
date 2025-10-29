; uchar esxdos_m_setdrv(uchar drive)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_m_setdrv

EXTERN asm_esxdos_m_getsetdrv

defc esxdos_m_setdrv = asm_esxdos_m_getsetdrv

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_m_setdrv
defc _esxdos_m_setdrv = esxdos_m_setdrv
ENDIF

