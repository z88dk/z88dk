; unsigned char extended_sna_load(unsigned char handle)

SECTION code_esxdos

PUBLIC _extended_sna_load

EXTERN asm_extended_sna_load

_extended_sna_load:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_extended_sna_load
