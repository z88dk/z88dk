; int esxdos_f_write(uchar handle, void *src, size_t nbyte)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_write_callee
PUBLIC l0_esxdos_f_write_callee

EXTERN asm_esxdos_f_write

_esxdos_f_write_callee:

   pop de
   dec sp
   pop af
   pop hl
   pop bc
   push de
   
l0_esxdos_f_write_callee:

   push ix
   push iy
   
   call asm_esxdos_f_write
   
   pop iy
   pop ix
   ret
