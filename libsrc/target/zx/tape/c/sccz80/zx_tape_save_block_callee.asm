; unsigned char zx_tape_save_block(void *src, unsigned int len, unsigned char type)

SECTION code_clib
SECTION code_arch

PUBLIC zx_tape_save_block_callee

EXTERN asm_zx_tape_save_block

zx_tape_save_block_callee:

   pop af
   pop bc
   pop de
   pop ix
   push af
   
   ld a,c
   jp asm_zx_tape_save_block
