; uchar esxdos_f_opendir(char *path)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_f_opendir

EXTERN asm_esxdos_f_opendir

esxdos_ram_f_opendir:

   ld a,__ESXDOS_DRIVE_CURRENT
   ld b,0
   
   push hl
   pop ix
   
   jp asm_esxdos_f_opendir
