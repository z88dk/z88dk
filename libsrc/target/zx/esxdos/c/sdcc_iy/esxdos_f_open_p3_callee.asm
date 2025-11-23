; uchar esxdos_f_open_p3(char *filename, uchar mode, void *header)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_open_p3_callee
PUBLIC l0_esxdos_f_open_p3_callee

EXTERN asm_esxdos_f_open

_esxdos_f_open_p3_callee:

   pop af
   pop hl
   dec sp
   pop bc
   pop de
   push af

l0_esxdos_f_open_p3_callee:

   ld a,__ESXDOS_DRIVE_CURRENT

   push iy
   
   call asm_esxdos_f_open

   pop iy
   ret
