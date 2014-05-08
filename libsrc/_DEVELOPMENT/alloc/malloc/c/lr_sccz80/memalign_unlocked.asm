
; void *memalign_unlocked(size_t alignment, size_t size)

PUBLIC memalign_unlocked

EXTERN aligned_alloc_unlocked

;defc memalign_unlocked = aligned_alloc_unlocked

memalign_unlocked:

   jp aligned_alloc_unlocked

