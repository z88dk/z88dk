; unsigned char esx_f_rmdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC _esx_f_rmdir_fastcall

EXTERN asm_esx_f_rmdir

defc _esx_f_rmdir_fastcall = asm_esx_f_rmdir
