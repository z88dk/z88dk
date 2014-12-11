
; void heap_free_unlocked(void *p)

SECTION code_alloc_malloc

PUBLIC _heap_free_unlocked

_heap_free_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "alloc/malloc/z80/asm_heap_free_unlocked.asm"
