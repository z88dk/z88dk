; unsigned char esx_f_stat(unsigned char *filename,struct esx_stat *es)

SECTION code_esxdos

PUBLIC _esx_f_stat

EXTERN asm_esx_f_stat

_esx_f_stat:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_esx_f_stat
