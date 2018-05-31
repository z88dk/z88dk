; unsigned char esx_f_trunc(unsigned char *filename,uint32_t size)

SECTION code_esxdos

PUBLIC _esx_f_trunc

EXTERN l0_esx_f_trunc_callee

_esx_f_trunc:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp l0_esx_f_trunc_callee
