
; void *memswap(void *s1, void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memswap

EXTERN asm_memswap

memswap:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_memswap
