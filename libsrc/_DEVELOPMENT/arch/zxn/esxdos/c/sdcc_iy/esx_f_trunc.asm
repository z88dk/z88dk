; unsigned char esx_f_trunc(unsigned char *filename,uint32_t size)

SECTION code_esxdos

PUBLIC _esx_f_trunc

EXTERN asm_esx_f_trunc

_esx_f_trunc:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_esx_f_trunc
