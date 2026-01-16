; unsigned char esx_f_rmdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC _esx_f_rmdir_fastcall

EXTERN asm_esx_f_rmdir

_esx_f_rmdir_fastcall:

   push ix
   
   call asm_esx_f_rmdir

   pop ix
   ret
