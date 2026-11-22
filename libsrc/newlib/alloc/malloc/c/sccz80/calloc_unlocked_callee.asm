
; void *calloc_unlocked(size_t nmemb, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC calloc_unlocked_callee

EXTERN asm_calloc_unlocked

calloc_unlocked_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_calloc_unlocked
