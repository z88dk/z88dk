; unsigned char esx_f_fstat(unsigned char handle, struct esx_stat *es)

SECTION code_esxdos

PUBLIC _esx_f_fstat

EXTERN l0_esx_f_fstat_callee

_esx_f_fstat:

   pop de
   dec sp
   pop af
   pop hl
   
   push hl
   push af
   inc sp
   push de
   
   jp l0_esx_f_fstat_callee
