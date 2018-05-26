; unsigned char extended_sna_load(unsigned char handle)

SECTION code_esxdos

PUBLIC _extended_sna_load

EXTERN _extended_sna_load_fastcall

_extended_sna_load:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _extended_sna_load_fastcall
