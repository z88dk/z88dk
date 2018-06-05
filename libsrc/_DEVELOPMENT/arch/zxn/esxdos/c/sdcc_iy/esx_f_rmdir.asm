; unsigned char esx_f_rmdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC _esx_f_rmdir

EXTERN asm_esx_f_rmdir

_esx_f_rmdir:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_f_rmdir
