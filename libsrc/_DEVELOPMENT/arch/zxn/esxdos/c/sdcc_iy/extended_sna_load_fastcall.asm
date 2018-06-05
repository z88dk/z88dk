; unsigned char extended_sna_load(unsigned char handle)

SECTION code_esxdos

PUBLIC _extended_sna_load_fastcall

EXTERN asm_extended_sna_load

defc _extended_sna_load_fastcall = asm_extended_sna_load
