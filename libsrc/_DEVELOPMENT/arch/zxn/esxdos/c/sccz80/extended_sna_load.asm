; unsigned char extended_sna_load(unsigned char *sna_file)

SECTION code_esxdos

PUBLIC extended_sna_load

EXTERN asm_extended_sna_load

defc extended_sna_load = asm_extended_sna_load
