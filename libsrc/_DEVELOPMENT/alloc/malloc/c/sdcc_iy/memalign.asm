
; void *memalign(size_t alignment, size_t size)

XDEF memalign

LIB aligned_alloc

memalign:

   jp aligned_alloc

   INCLUDE "alloc/malloc/z80/asm_memalign.asm"

