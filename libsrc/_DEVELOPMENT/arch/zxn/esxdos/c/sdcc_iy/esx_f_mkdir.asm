; unsigned char esx_f_mkdir(unsigned char *pathname)

SECTION code_esxdos

PUBLIC _esx_f_mkdir

EXTERN asm_esx_f_mkdir

_esx_f_mkdir:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_esx_f_mkdir
