; unsigned char esx_m_getdrv(void)

SECTION code_esxdos

PUBLIC _esx_m_getdrv

EXTERN asm_esx_m_getdrv

defc _esx_m_getdrv = asm_esx_m_getdrv
