; int esxdos_f_write(uchar handle, void *src, size_t nbyte)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_write

EXTERN l0_esxdos_f_write_callee

_esxdos_f_write:

   pop de
   dec sp
   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   dec sp
   push de
   
   jp l0_esxdos_f_write_callee
