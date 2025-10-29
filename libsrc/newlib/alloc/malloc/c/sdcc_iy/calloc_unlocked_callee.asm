
; void *calloc_unlocked_callee(size_t nmemb, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _calloc_unlocked_callee

EXTERN asm_calloc_unlocked

_calloc_unlocked_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_calloc_unlocked
