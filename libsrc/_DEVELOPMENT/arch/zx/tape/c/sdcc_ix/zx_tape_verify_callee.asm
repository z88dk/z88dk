; unsigned char zx_tape_verify(void *dst, unsigned int len, unsigned char type)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_tape_verify_callee

EXTERN asm_zx_tape_verify

_zx_tape_verify_callee:

   pop hl
   pop bc
   pop de
   dec sp
   ex (sp),hl
   
   ld a,h
   
l_zx_tape_verify_callee:

   push bc
   ex (sp),ix
   
   call asm_zx_tape_verify
   
   pop ix
   ret
