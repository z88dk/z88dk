; unsigned char esx_f_unlink(unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_f_unlink

EXTERN asm_esx_f_unlink

_esx_f_unlink:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_f_unlink
