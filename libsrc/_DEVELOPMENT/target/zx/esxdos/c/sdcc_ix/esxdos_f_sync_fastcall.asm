; int esxdos_f_sync(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_sync_fastcall

EXTERN asm_esxdos_f_sync

_esxdos_f_sync_fastcall:

   push ix
   push iy
   
   call asm_esxdos_f_sync
   
   pop iy
   pop ix
   ret
