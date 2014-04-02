
; void *memalign(size_t alignment, size_t size)

XDEF _memalign

LIB _aligned_alloc

_memalign:

   jp _aligned_alloc

   INCLUDE "alloc/malloc/z80/asm_memalign.asm"

