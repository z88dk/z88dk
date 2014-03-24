
; void heap_free_unlocked(void *p)

XDEF heap_free_unlocked

heap_free_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "alloc/malloc/z80/asm_heap_free_unlocked.asm"
