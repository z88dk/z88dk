; uint32_t esx_f_telldir(unsigned char handle)

SECTION code_esxdos

PUBLIC esx_f_telldir

EXTERN asm_esx_f_telldir

defc esx_f_telldir = asm_esx_f_telldir
