; unsigned char esx_f_rmdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC esx_f_rmdir

EXTERN asm_esx_f_rmdir

defc esx_f_rmdir = asm_esx_f_rmdir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_rmdir
defc _esx_f_rmdir = esx_f_rmdir
ENDIF

