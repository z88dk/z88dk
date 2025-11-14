
; void *memccpy_callee(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memccpy_callee, l0_memccpy_callee

EXTERN asm_memccpy

_memccpy_callee:

   pop af
   pop de
   pop hl
   exx
   pop bc
   exx
   pop bc
   push af

l0_memccpy_callee:

   exx
   ld a,c
   exx
   
   jp asm_memccpy
