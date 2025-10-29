
; int memcmp_callee(const void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memcmp_callee

EXTERN asm_memcmp

_memcmp_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_memcmp
