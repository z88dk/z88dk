
; void *memalign_unlocked(size_t alignment, size_t size)

SECTION seg_code_malloc

PUBLIC memalign_unlocked

EXTERN aligned_alloc_unlocked

defc memalign_unlocked = aligned_alloc_unlocked
