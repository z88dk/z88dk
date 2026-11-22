; unsigned char esx_f_ftrunc(unsigned char handle, uint32_t size)

SECTION code_esxdos

PUBLIC _esx_f_ftrunc_callee

EXTERN asm_esx_f_ftrunc

_esx_f_ftrunc_callee:

   pop hl
   dec sp
   pop af
   pop de
   pop bc
   push hl
   
   jp asm_esx_f_ftrunc
