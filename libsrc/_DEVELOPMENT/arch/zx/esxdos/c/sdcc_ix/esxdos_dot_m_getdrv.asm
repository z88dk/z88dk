; uchar esxdos_m_getdrv(void)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_dot_m_getdrv

EXTERN _esxdos_ram_m_getdrv

defc _esxdos_dot_m_getdrv = _esxdos_ram_m_getdrv
