; unsigned char esx_f_opendir(unsigned char *dirname)

SECTION code_esxdos

PUBLIC _esx_f_opendir_fastcall

EXTERN asm_esx_f_opendir

defc _esx_f_opendir_fastcall = asm_esx_f_opendir
