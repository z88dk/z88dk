; uchar esxdos_f_open_p3(char *filename, uchar mode, void *header)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_open_p3_callee

EXTERN asm_esxdos_f_open

esxdos_f_open_p3_callee:

   pop af
   pop de
   pop bc
   pop ix
   
   push bc
   push bc
   push de
   push af
   
   ld b,c
   jp asm_esxdos_f_open
