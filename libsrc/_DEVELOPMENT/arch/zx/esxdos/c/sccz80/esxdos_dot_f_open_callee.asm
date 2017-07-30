; uchar esxdos_f_open(char *filename, uchar mode)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_dot_f_open_callee

EXTERN asm_esxdos_f_open

esxdos_dot_f_open_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   ld b,c
   jp asm_esxdos_f_open
