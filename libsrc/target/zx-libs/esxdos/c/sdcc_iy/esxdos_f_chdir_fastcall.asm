; int esxdos_f_chdir(void *path)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_chdir_fastcall

EXTERN asm_esxdos_f_chdir

_esxdos_f_chdir_fastcall:

   ld a,__ESXDOS_DRIVE_CURRENT

   push iy
   
   call asm_esxdos_f_chdir
   
   pop iy
   ret
