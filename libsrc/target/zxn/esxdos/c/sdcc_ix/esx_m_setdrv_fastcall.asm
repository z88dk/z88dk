; unsigned char esx_m_setdrv(unsigned char drive)

SECTION code_esxdos

PUBLIC _esx_m_setdrv_fastcall

EXTERN asm_esx_m_setdrv

defc _esx_m_setdrv_fastcall = asm_esx_m_setdrv
