; unsigned char esx_f_rmdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC _esx_f_rmdir

EXTERN _esx_f_rmdir_fastcall

_esx_f_rmdir:

   pop af
   pop hl
   
   push hl
   push af

   jp _esx_f_rmdir_fastcall
