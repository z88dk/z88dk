; unsigned char esx_f_rename(unsigned char *old, unsigned char *new)

SECTION code_esxdos

PUBLIC _esx_f_rename

EXTERN l0_esx_f_rename_callee

_esx_f_rename:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp l0_esx_f_rename_callee
