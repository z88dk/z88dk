; unsigned char esx_f_opendir(unsigned char *dirname)

SECTION code_esxdos

PUBLIC _esx_f_opendir

EXTERN _esx_f_opendir_fastcall

_esx_f_opendir:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esx_f_opendir_fastcall
