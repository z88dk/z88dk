
; void *heap_alloc_fixed_unlocked(void *heap, void *p, size_t size)

XDEF heap_alloc_fixed_unlocked

heap_alloc_fixed_unlocked:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_fixed_unlocked.asm"
