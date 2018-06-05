; unsigned char esx_f_mkdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC esx_f_mkdir

EXTERN asm_esx_f_mkdir

defc esx_f_mkdir = asm_esx_f_mkdir
