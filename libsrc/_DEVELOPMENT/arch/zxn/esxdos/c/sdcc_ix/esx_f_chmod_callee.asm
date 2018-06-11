; unsigned char esx_f_chmod(unsigned char *filename, uint8_t attr_mask, uint8_t attr)

SECTION code_esxdos

PUBLIC _esx_f_chmod_callee
PUBLIC l0_esx_f_chmod_callee

EXTERN asm_esx_f_chmod

_esx_f_chmod_callee:

   pop af
   pop hl
   pop bc
   push af

l0_esx_f_chmod_callee:

   push ix
   
   call asm_esx_f_chmod

   pop ix
   ret
