; int esxdos_f_unlink(void *filename)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_unlink

EXTERN asm_esxdos_f_unlink

esxdos_f_unlink:

   ld a,__ESXDOS_DRIVE_CURRENT
   jp asm_esxdos_f_unlink
