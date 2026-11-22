; uchar esxdos_f_open(char *filename, uchar mode)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_open_callee
PUBLIC l0_esxdos_f_open_callee

EXTERN asm_esxdos_f_open

_esxdos_f_open_callee:

   pop af
   pop hl
   dec sp
   pop bc
   push af

l0_esxdos_f_open_callee:

   ld a,__ESXDOS_DRIVE_CURRENT
   ld de,0

   push ix
   push iy
   
   call asm_esxdos_f_open

   pop iy
   pop ix
   ret
