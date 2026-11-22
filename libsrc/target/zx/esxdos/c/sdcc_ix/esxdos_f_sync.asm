; int esxdos_f_sync(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_sync

EXTERN _esxdos_f_sync_fastcall

_esxdos_f_sync:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esxdos_f_sync_fastcall
