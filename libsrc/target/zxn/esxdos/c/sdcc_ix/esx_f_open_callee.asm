; unsigned char esx_f_open(unsigned char *filename,unsigned char mode)

SECTION code_esxdos

PUBLIC _esx_f_open_callee
PUBLIC l0_esx_f_open_callee

EXTERN asm_esx_f_open

_esx_f_open_callee:

   pop de
   pop hl
   dec sp
   pop af
   push de

l0_esx_f_open_callee:

   push ix
   
   call asm_esx_f_open

   pop ix
   ret
