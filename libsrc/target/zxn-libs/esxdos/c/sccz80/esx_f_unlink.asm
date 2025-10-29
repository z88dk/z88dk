; unsigned char esx_f_unlink(unsigned char *filename)

SECTION code_esxdos

PUBLIC esx_f_unlink

EXTERN asm_esx_f_unlink

defc esx_f_unlink = asm_esx_f_unlink

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_unlink
defc _esx_f_unlink = esx_f_unlink
ENDIF

