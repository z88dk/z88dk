
; void *realloc_unlocked_callee(void *p, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _realloc_unlocked_callee

EXTERN asm_realloc_unlocked

_realloc_unlocked_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_realloc_unlocked
