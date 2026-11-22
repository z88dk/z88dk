; unsigned char esx_f_chdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC _esx_f_chdir

EXTERN _esx_f_chdir_fastcall

_esx_f_chdir:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esx_f_chdir_fastcall
