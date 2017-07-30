; uchar esxdos_f_open(char *filename, uchar mode)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_f_open

EXTERN asm_esxdos_f_open

esxdos_ram_f_open:

   pop af
   pop bc
   pop ix
   
   push bc
   push bc
   push af
   
   ld b,c
   jp asm_esxdos_f_open
