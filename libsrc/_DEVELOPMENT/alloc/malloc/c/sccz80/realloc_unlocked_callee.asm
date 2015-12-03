
; void *realloc_unlocked(void *p, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC realloc_unlocked_callee

EXTERN asm_realloc_unlocked

realloc_unlocked_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_realloc_unlocked
