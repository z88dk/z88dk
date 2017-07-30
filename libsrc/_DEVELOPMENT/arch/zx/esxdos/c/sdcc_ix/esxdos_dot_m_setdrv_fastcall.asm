; uchar esxdos_m_setdrv(uchar drive)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_dot_m_setdrv_fastcall

EXTERN _esxdos_ram_m_setdrv_fastcall

defc _esxdos_dot_m_setdrv_fastcall = _esxdos_ram_m_setdrv_fastcall
