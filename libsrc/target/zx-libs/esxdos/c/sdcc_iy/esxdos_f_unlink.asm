; int esxdos_f_unlink(void *filename)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_unlink

EXTERN _esxdos_f_unlink_fastcall

_esxdos_f_unlink:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esxdos_f_unlink_fastcall
