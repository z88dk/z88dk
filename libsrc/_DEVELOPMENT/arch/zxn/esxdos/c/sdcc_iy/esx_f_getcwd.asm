; unsigned char esx_f_getcwd(unsigned char *buf)

SECTION code_esxdos

PUBLIC _esx_f_getcwd

EXTERN asm_esx_f_getcwd

_esx_f_getcwd:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_esx_f_getcwd
