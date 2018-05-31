; uint32_t esx_f_fgetpos(unsigned char handle)

SECTION code_esxdos

PUBLIC esx_f_getpos

EXTERN asm_esx_f_fgetpos

defc esx_f_getpos = asm_esx_f_fgetpos
