
; void *memswap(void *s1, void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memswap

EXTERN asm_memswap

_memswap:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_memswap
