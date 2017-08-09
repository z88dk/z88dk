; uchar esxdos_m_gethandle(void)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_dot_m_gethandle

EXTERN _esxdos_ram_m_gethandle

defc _esxdos_dot_m_gethandle = _esxdos_ram_m_gethandle
