
; void *heap_realloc_unlocked(void *heap, void *p, size_t size)

XDEF heap_realloc_unlocked

heap_realloc_unlocked:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_realloc_unlocked.asm"
