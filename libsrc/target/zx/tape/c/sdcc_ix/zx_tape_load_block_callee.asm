; unsigned char zx_tape_load_block(void *dst, unsigned int len, unsigned char type)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_tape_load_block_callee

EXTERN asm_zx_tape_load_block

_zx_tape_load_block_callee:

   pop hl
   pop bc
   pop de
   dec sp
   ex (sp),hl
   
   ld a,h
   
l_zx_tape_load_block_callee:

   push bc
   ex (sp),ix
   
   call asm_zx_tape_load_block
   
   pop ix
   ret
