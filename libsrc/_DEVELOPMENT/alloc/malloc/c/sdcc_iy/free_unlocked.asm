
; void free_unlocked(void *p)

XDEF _free_unlocked

LIB _heap_free_unlocked

_free_unlocked:

   jp _heap_free_unlocked

   INCLUDE "alloc/malloc/z80/asm_free_unlocked.asm"
