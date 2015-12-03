
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memccpy_callee, l0_memccpy_callee

EXTERN asm_memccpy

memccpy_callee:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push af

l0_memccpy_callee:

   ld a,ixl
      
   jp asm_memccpy
