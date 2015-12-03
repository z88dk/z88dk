
; void *malloc_unlocked(size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC malloc_unlocked

EXTERN asm_malloc_unlocked

defc malloc_unlocked = asm_malloc_unlocked
