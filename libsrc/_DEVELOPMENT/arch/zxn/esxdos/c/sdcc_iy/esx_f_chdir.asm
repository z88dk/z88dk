; unsigned char esx_f_chdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC _esx_f_chdir

EXTERN asm_esx_f_chdir

_esx_f_chdir:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_esx_f_chdir
