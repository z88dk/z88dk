; unsigned char esx_f_readdir(unsigned char handle,struct esx_dirent *dirent)

SECTION code_esxdos

PUBLIC _esx_f_readdir_callee
PUBLIC l0_esx_f_readdir_callee

EXTERN asm_esx_f_readdir

_esx_f_readdir_callee:

   pop hl
   dec sp
   pop af
   ex (sp),hl

l0_esx_f_readdir_callee:

   push iy

   call asm_esx_f_readdir

   pop iy
   ret
