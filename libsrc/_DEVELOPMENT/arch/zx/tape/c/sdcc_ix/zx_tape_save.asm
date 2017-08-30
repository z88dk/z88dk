; unsigned char zx_tape_save(void *src, unsigned int len, unsigned char type)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_tape_save

EXTERN l_zx_tape_save_callee

_zx_tape_save:

   pop hl
   pop bc
   pop de
   dec sp
   pop af
   
   push af
   dec sp
   push bc
   push hl
   
   jp l_zx_tape_save_callee
