; unsigned char zx_tape_save(void *src, unsigned int len, unsigned char type)

SECTION code_clib
SECTION code_arch

PUBLIC zx_tape_save_callee

EXTERN asm_zx_tape_save

zx_tape_save_callee:

   pop af
   pop bc
   pop de
   pop ix
   push af
   
   ld a,c
   jp asm_zx_tape_save
