
; void free_unlocked(void *p)

PUBLIC _free_unlocked

EXTERN _heap_free_unlocked

_free_unlocked:

   jp _heap_free_unlocked

   INCLUDE "alloc/malloc/z80/asm_free_unlocked.asm"
