; ulong esxdos_m_getdate(void)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_m_getdate

EXTERN asm_esxdos_m_getdate

defc esxdos_ram_m_getdate = asm_esxdos_m_getdate
