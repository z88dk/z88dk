
; void free_unlocked(void *p)

XDEF free_unlocked

LIB heap_free_unlocked

free_unlocked:

   jp heap_free_unlocked

   INCLUDE "alloc/malloc/z80/asm_free_unlocked.asm"
