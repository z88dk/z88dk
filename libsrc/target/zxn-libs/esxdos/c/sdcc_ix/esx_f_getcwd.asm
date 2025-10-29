; unsigned char esx_f_getcwd(unsigned char *buf)

SECTION code_esxdos

PUBLIC _esx_f_getcwd

EXTERN _esx_f_getcwd_fastcall

_esx_f_getcwd:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esx_f_getcwd_fastcall
