; unsigned char esx_f_seekdir(unsigned char handle,uint32_t pos)

SECTION code_esxdos

PUBLIC _esx_f_seekdir

EXTERN asm_esx_f_seekdir

_esx_f_seekdir:

   pop hl
   dec sp
   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   inc sp
   push hl
   
   jp asm_esx_f_seekdir
