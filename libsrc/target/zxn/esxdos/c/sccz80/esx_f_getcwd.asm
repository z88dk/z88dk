; unsigned char esx_f_getcwd(unsigned char *buf)

SECTION code_esxdos

PUBLIC esx_f_getcwd

EXTERN asm_esx_f_getcwd

defc esx_f_getcwd = asm_esx_f_getcwd

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_getcwd
defc _esx_f_getcwd = esx_f_getcwd
ENDIF

