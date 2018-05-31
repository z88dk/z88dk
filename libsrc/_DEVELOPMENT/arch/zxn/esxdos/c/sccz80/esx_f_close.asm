; unsigned char esx_f_close(unsigned char handle)

SECTION code_esxdos

PUBLIC esx_f_close

EXTERN asm_esx_f_close

defc esx_f_close = asm_esx_f_close
