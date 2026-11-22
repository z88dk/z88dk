; ulong esxdos_f_seek(uchar handle, ulong dist, uchar whence)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_seek

EXTERN l0_esxdos_f_seek_callee

_esxdos_f_seek:

   pop af
   ex af,af'
   dec sp
   pop af
   pop de
   pop bc
   dec sp
   pop hl
   
   dec sp
   push bc
   push de
   dec sp
   ex af,af'
   push af
   ex af,af'

   jp l0_esxdos_f_seek_callee
