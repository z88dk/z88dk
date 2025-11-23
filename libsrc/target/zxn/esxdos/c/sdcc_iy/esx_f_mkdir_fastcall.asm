; unsigned char esx_f_mkdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC _esx_f_mkdir_fastcall

EXTERN asm_esx_f_mkdir

_esx_f_mkdir_fastcall:

   push iy
   
   call asm_esx_f_mkdir

   pop iy
   ret
