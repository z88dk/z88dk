
; void *memalign_unlocked(size_t alignment, size_t size)

PUBLIC _memalign_unlocked

EXTERN _aligned_alloc_unlocked

_memalign_unlocked:

   jp _aligned_alloc_unlocked

   INCLUDE "alloc/malloc/z80/asm_memalign_unlocked.asm"
