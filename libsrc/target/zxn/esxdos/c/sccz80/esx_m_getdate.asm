; unsigned char esx_m_getdate(struct dos_tm *)

SECTION code_esxdos

PUBLIC esx_m_getdate

EXTERN asm_esx_m_getdate

defc esx_m_getdate = asm_esx_m_getdate

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_getdate
defc _esx_m_getdate = esx_m_getdate
ENDIF

