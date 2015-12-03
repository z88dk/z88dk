
; void *memswap_callee(void *s1, void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memswap_callee

EXTERN asm_memswap

_memswap:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_memswap
