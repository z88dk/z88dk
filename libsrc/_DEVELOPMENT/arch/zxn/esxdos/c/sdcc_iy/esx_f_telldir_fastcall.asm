; uint32_t esx_f_telldir(unsigned char handle)

SECTION code_esxdos

PUBLIC _esx_f_telldir_fastcall

EXTERN asm_esx_f_telldir

defc _esx_f_telldir_fastcall = asm_esx_f_telldir
