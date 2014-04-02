
; void *memalign_unlocked(size_t alignment, size_t size)

XDEF _memalign_unlocked

LIB _aligned_alloc_unlocked

_memalign_unlocked:

   jp _aligned_alloc_unlocked

   INCLUDE "alloc/malloc/z80/asm_memalign_unlocked.asm"
