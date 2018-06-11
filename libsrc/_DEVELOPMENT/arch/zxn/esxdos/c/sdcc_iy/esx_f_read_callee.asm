; uint16_t esx_f_read(unsigned char handle, void *dst, size_t nbytes)

SECTION code_esxdos

PUBLIC _esx_f_read_callee
PUBLIC l0_esx_f_read_callee

EXTERN asm_esx_f_read

_esx_f_read_callee:

   pop de
   dec sp
   pop af
   pop hl
   pop bc
   push de

l0_esx_f_read_callee:

   push iy
   
   call asm_esx_f_read

   pop iy
   ret
