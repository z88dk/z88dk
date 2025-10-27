
; void *memcpy_callee(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memcpy_callee

EXTERN asm_memcpy

_memcpy_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_memcpy
