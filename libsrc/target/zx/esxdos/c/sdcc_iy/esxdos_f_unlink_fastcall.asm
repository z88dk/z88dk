; int esxdos_f_unlink(void *filename)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_unlink_fastcall

EXTERN asm_esxdos_f_unlink

_esxdos_f_unlink_fastcall:

   ld a,__ESXDOS_DRIVE_CURRENT
   
   push iy
   
   call asm_esxdos_f_unlink
   
   pop iy
   ret
