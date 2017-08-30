; unsigned char zx_tape_verify(void *dst, unsigned int len, unsigned char type)

SECTION code_clib
SECTION code_arch

PUBLIC zx_tape_verify

EXTERN asm_zx_tape_verify

zx_tape_verify:

   pop af
   pop bc
   pop de
   pop ix
   
   push de
   push de
   push bc
   push af
   
   ld a,c
   jp asm_zx_tape_verify
