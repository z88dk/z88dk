
; void *memalign_unlocked(size_t alignment, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _memalign_unlocked

EXTERN _aligned_alloc_unlocked

defc _memalign_unlocked = _aligned_alloc_unlocked
