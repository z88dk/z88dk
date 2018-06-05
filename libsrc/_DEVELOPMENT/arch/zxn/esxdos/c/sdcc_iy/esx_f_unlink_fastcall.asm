; unsigned char esx_f_unlink(unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_f_unlink_fastcall

EXTERN asm_esx_f_unlink

defc _esx_f_unlink_fastcall = asm_esx_f_unlink
