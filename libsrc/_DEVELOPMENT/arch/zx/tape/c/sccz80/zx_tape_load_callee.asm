; unsigned char zx_tape_load(void *dst, unsigned int len, unsigned char type)

SECTION code_clib
SECTION code_arch

PUBLIC zx_tape_load_callee

EXTERN asm_zx_tape_load

zx_tape_load_callee:

   pop af
   pop bc
   pop de
   pop ix
   push af
   
   ld a,c
   jp asm_zx_tape_load
