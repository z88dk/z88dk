; int esxdos_f_read(uchar handle, void *dst, size_t nbyte)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_read

EXTERN l0_esxdos_f_read_callee

_esxdos_f_read:

   pop de
   dec sp
   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   dec sp
   push de
   
   jp l0_esxdos_f_read_callee
