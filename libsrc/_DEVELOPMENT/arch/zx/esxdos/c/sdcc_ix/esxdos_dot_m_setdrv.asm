; uchar esxdos_m_setdrv(uchar drive)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_dot_m_setdrv

EXTERN _esxdos_ram_m_setdrv

defc _esxdos_dot_m_setdrv = _esxdos_ram_m_setdrv
