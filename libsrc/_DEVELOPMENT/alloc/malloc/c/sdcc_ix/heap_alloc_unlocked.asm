
; void *heap_alloc_unlocked(void *heap, size_t size)

XDEF _heap_alloc_unlocked

_heap_alloc_unlocked:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_unlocked.asm"
