; unsigned char esx_f_mkdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC esx_f_mkdir

EXTERN asm_esx_f_mkdir

defc esx_f_mkdir = asm_esx_f_mkdir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_mkdir
defc _esx_f_mkdir = esx_f_mkdir
ENDIF

