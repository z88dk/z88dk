; ulong esxdos_m_getdate(void)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_dot_m_getdate

EXTERN _esxdos_ram_m_getdate

defc _esxdos_dot_m_getdate = _esxdos_ram_m_getdate
