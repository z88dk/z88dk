; uint32_t esx_f_fgetpos(unsigned char handle)

SECTION code_esxdos

PUBLIC _esx_f_getpos_fastcall

EXTERN asm_esx_f_fgetpos

defc _esx_f_getpos_fastcall = asm_esx_f_fgetpos
