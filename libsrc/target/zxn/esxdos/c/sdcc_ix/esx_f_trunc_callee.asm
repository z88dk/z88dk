; unsigned char esx_f_trunc(unsigned char *filename,uint32_t size)

SECTION code_esxdos

PUBLIC _esx_f_trunc_callee
PUBLIC l0_esx_f_trunc_callee

EXTERN asm_esx_f_trunc

_esx_f_trunc_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_esx_f_trunc_callee:

   push ix
   
   call asm_esx_f_trunc

   pop ix
   ret
