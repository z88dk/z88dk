; uint32_t esx_f_getfree(void)

SECTION code_esxdos

PUBLIC esx_f_getfree

EXTERN asm_esx_f_getfree

defc esx_f_getfree = asm_esx_f_getfree

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_getfree
defc _esx_f_getfree = esx_f_getfree
ENDIF

