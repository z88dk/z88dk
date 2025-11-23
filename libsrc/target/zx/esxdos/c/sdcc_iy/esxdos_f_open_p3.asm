; uchar esxdos_f_open_p3(char *filename, uchar mode, void *header)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_open_p3

EXTERN l0_esxdos_f_open_p3_callee

_esxdos_f_open_p3:

   pop af
   pop hl
   dec sp
   pop bc
   pop de
   
   push de
   dec sp
   push hl
   push af

   jp l0_esxdos_f_open_p3_callee
