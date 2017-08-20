; ulong esxdos_f_fgetpos(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_fgetpos

EXTERN _esxdos_f_fgetpos_fastcall

_esxdos_f_fgetpos:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esxdos_f_fgetpos_fastcall
