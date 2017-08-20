; uchar esxdos_f_readdir(uchar handle, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_readdir

EXTERN l0_esxdos_f_readdir_callee

_esxdos_f_readdir:

   pop de
   dec sp
   pop af
   pop hl
   
   push hl
   dec sp
   push de

   jp l0_esxdos_f_readdir_callee
