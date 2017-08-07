; uchar esxdos_m_setdrv(uchar drive)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_dot_m_setdrv

EXTERN asm_esxdos_m_getsetdrv

defc esxdos_dot_m_setdrv = asm_esxdos_m_getsetdrv
