
; void *memalign_unlocked(size_t alignment, size_t size)

XLIB memalign_unlocked

LIB aligned_alloc_unlocked

defc memalign_unlocked = aligned_alloc_unlocked
