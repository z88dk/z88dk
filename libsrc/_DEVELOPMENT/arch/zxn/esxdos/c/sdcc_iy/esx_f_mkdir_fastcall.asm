; unsigned char esx_f_mkdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC _esx_f_mkdir_fastcall

EXTERN asm_esx_f_mkdir

defc _esx_f_mkdir_fastcall = asm_esx_f_mkdir
