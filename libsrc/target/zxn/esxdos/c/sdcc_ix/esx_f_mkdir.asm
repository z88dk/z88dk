; unsigned char esx_f_mkdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC _esx_f_mkdir

EXTERN _esx_f_mkdir_fastcall

_esx_f_mkdir:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esx_f_mkdir_fastcall
