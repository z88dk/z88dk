; uchar esxdos_f_opendir_p3(char *path)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_opendir_p3

EXTERN _esxdos_f_opendir_p3_fastcall

_esxdos_f_opendir_p3:

   pop af
   pop hl

   push hl
   push af

   jp _esxdos_f_opendir_p3_fastcall
