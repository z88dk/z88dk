; unsigned char esx_f_opendir(unsigned char *dirname)

SECTION code_esxdos

PUBLIC esx_f_opendir

EXTERN asm_esx_f_opendir

defc esx_f_opendir = asm_esx_f_opendir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_opendir
defc _esx_f_opendir = esx_f_opendir
ENDIF

