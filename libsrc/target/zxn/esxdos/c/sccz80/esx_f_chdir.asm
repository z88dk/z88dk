; unsigned char esx_f_chdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC esx_f_chdir

EXTERN asm_esx_f_chdir

defc esx_f_chdir = asm_esx_f_chdir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_chdir
defc _esx_f_chdir = esx_f_chdir
ENDIF

