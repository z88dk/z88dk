; uint16_t esx_f_write(unsigned char handle, void *src, size_t nbytes)

SECTION code_esxdos

PUBLIC _esx_f_write_callee
PUBLIC l0_esx_f_write_callee

EXTERN asm_esx_f_write

_esx_f_write_callee:

   pop de
   dec sp
   pop af
   pop hl
   pop bc
   push de

l0_esx_f_write_callee:

   push ix
   
   call asm_esx_f_write

   pop ix
   ret
