; unsigned char esx_f_rename(unsigned char *old, unsigned char *new)

SECTION code_esxdos

PUBLIC _esx_f_rename

EXTERN asm_esx_f_rename

_esx_f_rename:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_esx_f_rename
