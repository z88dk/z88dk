
; void *memswap(void *s1, void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memswap_callee

EXTERN asm_memswap

memswap_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_memswap
