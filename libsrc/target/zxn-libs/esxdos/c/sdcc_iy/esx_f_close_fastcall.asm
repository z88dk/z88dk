; unsigned char esx_f_close(unsigned char handle)

SECTION code_esxdos

PUBLIC _esx_f_close_fastcall

EXTERN asm_esx_f_close

defc _esx_f_close_fastcall = asm_esx_f_close
