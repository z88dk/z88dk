; unsigned char esx_f_stat(unsigned char *filename,struct esx_stat *es)

SECTION code_esxdos

PUBLIC _esx_f_stat

EXTERN l0_esx_f_stat_callee

_esx_f_stat:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp l0_esx_f_stat_callee
