; unsigned char esx_f_seekdir(unsigned char handle,uint32_t pos)

SECTION code_esxdos

PUBLIC _esx_f_seekdir_callee

EXTERN asm_esx_f_seekdir

_esx_f_seekdir_callee:

   pop hl
   dec sp
   pop af
   pop de
   pop bc
   push hl
   
   jp asm_esx_f_seekdir
