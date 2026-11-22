; unsigned char extended_sna_load(unsigned char handle)

SECTION code_esxdos

PUBLIC extended_sna_load

EXTERN asm_extended_sna_load

defc extended_sna_load = asm_extended_sna_load

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _extended_sna_load
defc _extended_sna_load = extended_sna_load
ENDIF

