; uchar esxdos_m_getdrv(void)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_dot_m_getdrv

EXTERN esxdos_ram_m_getdrv

defc esxdos_dot_m_getdrv = esxdos_ram_m_getdrv
