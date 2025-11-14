; int esxdos_f_read(uchar handle, void *dst, size_t nbyte)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_read_callee
PUBLIC l0_esxdos_f_read_callee

EXTERN asm_esxdos_f_read

_esxdos_f_read_callee:

   pop de
   dec sp
   pop af
   pop hl
   pop bc
   push de
   
l0_esxdos_f_read_callee:

   push iy
   
   call asm_esxdos_f_read
   
   pop iy
   ret
