; unsigned char esx_f_open_p3(unsigned char *filename,unsigned char mode,struct esx_p3_hdr *h)

SECTION code_esxdos

PUBLIC _esx_f_open_p3_callee
PUBLIC l0_esx_f_open_p3_callee

EXTERN asm_esx_f_open_p3

_esx_f_open_p3_callee:

   pop bc
   pop hl
   dec sp
   pop af
   pop de
   push bc

l0_esx_f_open_p3_callee:

   push ix
   
   call asm_esx_f_open_p3

   pop ix
   ret
