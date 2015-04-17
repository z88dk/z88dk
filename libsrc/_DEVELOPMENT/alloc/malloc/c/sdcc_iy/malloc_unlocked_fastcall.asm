
; void *malloc_unlocked_fastcall(size_t size)

SECTION code_alloc_malloc

PUBLIC _malloc_unlocked_fastcall

_malloc_unlocked_fastcall:

   INCLUDE "alloc/malloc/z80/asm_malloc_unlocked.asm"
