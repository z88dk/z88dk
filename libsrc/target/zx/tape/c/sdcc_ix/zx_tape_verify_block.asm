; unsigned char zx_tape_verify_block(void *dst, unsigned int len, unsigned char type)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_tape_verify_block

EXTERN l_zx_tape_verify_block_callee

_zx_tape_verify_block:

   pop hl
   pop bc
   pop de
   dec sp
   pop af
   
   push af
   dec sp
   push bc
   push hl
   
   jp l_zx_tape_verify_block_callee
