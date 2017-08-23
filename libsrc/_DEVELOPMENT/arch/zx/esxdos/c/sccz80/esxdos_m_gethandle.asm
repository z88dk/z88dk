; uchar esxdos_m_gethandle(void)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_m_gethandle

EXTERN asm_esxdos_m_gethandle

defc esxdos_m_gethandle = asm_esxdos_m_gethandle
