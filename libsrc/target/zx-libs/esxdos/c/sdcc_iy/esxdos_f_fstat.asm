; int esxdos_f_fstat(uchar handle, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_fstat

EXTERN l0_esxdos_f_fstat_callee

_esxdos_f_fstat:

   pop bc
   dec sp
   pop af
   pop hl
   
   push hl
   dec sp
   push bc
   
   jp l0_esxdos_f_fstat_callee
