
; void *memalign_unlocked(size_t alignment, size_t size)

XDEF memalign_unlocked

LIB aligned_alloc_unlocked

memalign_unlocked:

   jp aligned_alloc_unlocked

   INCLUDE "alloc/malloc/z80/asm_memalign_unlocked.asm"
