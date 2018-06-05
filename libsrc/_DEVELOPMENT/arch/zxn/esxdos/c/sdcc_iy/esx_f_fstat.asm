; unsigned char esx_f_fstat(unsigned char handle, struct esx_stat *es)

SECTION code_esxdos

PUBLIC _esx_f_fstat

EXTERN asm_esx_f_fstat

_esx_f_fstat:

   pop de
   dec sp
   pop af
   pop hl
   
   push hl
   push af
   inc sp
   push de
   
   jp asm_esx_f_fstat
