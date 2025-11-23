; unsigned char esx_f_fstat(unsigned char handle, struct esx_stat *es)

SECTION code_esxdos

PUBLIC _esx_f_fstat_callee
PUBLIC l0_esx_f_fstat_callee

EXTERN asm_esx_f_fstat

_esx_f_fstat_callee:

   pop hl
   dec sp
   pop af
   ex (sp),hl

l0_esx_f_fstat_callee:

   push iy
   
   call asm_esx_f_fstat

   pop iy
   ret
