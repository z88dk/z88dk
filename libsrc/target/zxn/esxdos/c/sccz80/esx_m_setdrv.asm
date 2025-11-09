; unsigned char esx_m_setdrv(unsigned char drive)

SECTION code_esxdos

PUBLIC esx_m_setdrv

EXTERN asm_esx_m_setdrv

defc esx_m_setdrv = asm_esx_m_setdrv

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_setdrv
defc _esx_m_setdrv = esx_m_setdrv
ENDIF

