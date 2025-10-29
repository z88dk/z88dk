; ulong esxdos_f_fgetpos(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_fgetpos_fastcall

EXTERN asm_esxdos_f_fgetpos

_esxdos_f_fgetpos_fastcall:

   push iy
   
   call asm_esxdos_f_fgetpos
   
   pop iy
   ret
