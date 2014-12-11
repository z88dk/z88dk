
; void *malloc_unlocked(size_t size)

SECTION code_alloc_malloc

PUBLIC malloc_unlocked

malloc_unlocked:

   INCLUDE "alloc/malloc/z80/asm_malloc_unlocked.asm"
