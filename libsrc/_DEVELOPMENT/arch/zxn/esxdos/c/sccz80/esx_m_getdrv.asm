; unsigned char esx_m_getdrv(void)

SECTION code_esxdos

PUBLIC esx_m_getdrv

EXTERN asm_esx_m_getdrv

defc esx_m_getdrv = asm_esx_m_getdrv

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_getdrv
defc _esx_m_getdrv = esx_m_getdrv
ENDIF

