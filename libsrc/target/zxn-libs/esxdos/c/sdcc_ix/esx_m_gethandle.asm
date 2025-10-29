; unsigned char esx_m_gethandle(void)

SECTION code_esxdos

PUBLIC _esx_m_gethandle

EXTERN asm_esx_m_gethandle

defc _esx_m_gethandle = asm_esx_m_gethandle
