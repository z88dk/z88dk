
; void *memalign_unlocked(size_t alignment, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC memalign_unlocked

EXTERN aligned_alloc_unlocked

defc memalign_unlocked = aligned_alloc_unlocked
