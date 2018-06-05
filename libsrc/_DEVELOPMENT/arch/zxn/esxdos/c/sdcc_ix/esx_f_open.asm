; unsigned char esx_f_open(unsigned char *filename,unsigned char mode)

SECTION code_esxdos

PUBLIC _esx_f_open

EXTERN l0_esx_f_open_callee

_esx_f_open:

   pop de
   pop hl
   dec sp
   pop af
   
   push af
   inc sp
   push hl
   push de
   
   jp l0_esx_f_open_callee
