; unsigned char esx_f_stat(unsigned char *filename,struct esx_stat *es)

SECTION code_esxdos

PUBLIC _esx_f_stat_callee
PUBLIC l0_esx_f_stat_callee

EXTERN asm_esx_f_stat

_esx_f_stat_callee:

   pop af
   pop hl
   pop de
   push af

l0_esx_f_stat_callee:

   push iy
   
   call asm_esx_f_stat

   pop iy
   ret
