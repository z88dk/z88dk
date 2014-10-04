
; void heap_free_unlocked(void *p)

SECTION seg_code_malloc

PUBLIC heap_free_unlocked

heap_free_unlocked:

   INCLUDE "alloc/malloc/z80/asm_heap_free_unlocked.asm"
