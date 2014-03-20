
; void *heap_realloc_unlocked(void *heap, void *p, size_t size)

XDEF heap_realloc_unlocked

heap_realloc_unlocked:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_heap_realloc_unlocked.asm"
