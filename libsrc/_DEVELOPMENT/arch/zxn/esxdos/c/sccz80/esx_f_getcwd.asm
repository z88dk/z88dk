; unsigned char esx_f_getcwd(unsigned char *buf)

SECTION code_esxdos

PUBLIC esx_f_getcwd

EXTERN asm_esx_f_getcwd

defc esx_f_getcwd = asm_esx_f_getcwd
