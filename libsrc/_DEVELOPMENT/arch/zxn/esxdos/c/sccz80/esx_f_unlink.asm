; unsigned char esx_f_unlink(unsigned char *filename)

SECTION code_esxdos

PUBLIC esx_f_unlink

EXTERN asm_esx_f_unlink

defc esx_f_unlink = asm_esx_f_unlink
