; unsigned char esx_f_opendir(unsigned char *dirname)

SECTION code_esxdos

PUBLIC _esx_f_opendir_fastcall

EXTERN asm_esx_f_opendir

_esx_f_opendir_fastcall:

   push ix
   
   call asm_esx_f_opendir

   pop ix
   ret
