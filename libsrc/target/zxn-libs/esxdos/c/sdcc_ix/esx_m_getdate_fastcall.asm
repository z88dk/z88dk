; unsigned char esx_m_getdate(struct dos_tm *)

SECTION code_esxdos

PUBLIC _esx_m_getdate_fastcall

EXTERN asm_esx_m_getdate

defc _esx_m_getdate_fastcall = asm_esx_m_getdate
