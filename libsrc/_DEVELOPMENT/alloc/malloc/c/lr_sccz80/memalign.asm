
; void *memalign(size_t alignment, size_t size)

XLIB memalign

LIB aligned_alloc

;defc memalign = aligned_alloc

memalign:

   jp aligned_alloc

