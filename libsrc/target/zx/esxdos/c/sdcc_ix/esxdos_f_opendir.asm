; uchar esxdos_f_opendir(char *path)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_opendir

EXTERN _esxdos_f_opendir_fastcall

_esxdos_f_opendir:

   pop af
   pop hl

   push hl
   push af
	
	jp _esxdos_f_opendir_fastcall
