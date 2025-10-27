
; void free_unlocked(void *p)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC free_unlocked

EXTERN asm_free_unlocked

defc free_unlocked = asm_free_unlocked
