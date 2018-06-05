; unsigned char esx_f_opendir(unsigned char *dirname)

SECTION code_esxdos

PUBLIC _esx_f_opendir

EXTERN asm_esx_f_opendir

_esx_f_opendir:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_esx_f_opendir
