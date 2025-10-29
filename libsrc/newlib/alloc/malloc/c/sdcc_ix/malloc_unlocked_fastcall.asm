
; void *malloc_unlocked_fastcall(size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _malloc_unlocked_fastcall

EXTERN asm_malloc_unlocked

defc _malloc_unlocked_fastcall = asm_malloc_unlocked
