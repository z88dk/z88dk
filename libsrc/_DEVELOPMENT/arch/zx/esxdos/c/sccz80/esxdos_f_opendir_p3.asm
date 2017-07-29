; uchar esxdos_f_opendir_p3(char *path)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_opendir_p3_fastcall

EXTERN asm_esxdos_f_opendir

esxdos_f_opendir_p3_fastcall:

   ld a,__ESXDOS_DRIVE_CURRENT
   ld b,__ESXDOS_MODE_USE_HEADER
   
   push hl
   pop ix
   
   jp asm_esxdos_f_opendir
