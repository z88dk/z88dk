
; void heap_free_unlocked(void *p)

SECTION code_alloc_malloc

PUBLIC heap_free_unlocked

heap_free_unlocked:

   INCLUDE "alloc/malloc/z80/asm_heap_free_unlocked.asm"
