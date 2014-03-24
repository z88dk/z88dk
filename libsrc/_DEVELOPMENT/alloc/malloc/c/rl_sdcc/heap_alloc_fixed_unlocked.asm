
; void *heap_alloc_fixed_unlocked(void *heap, void *p, size_t size)

XDEF heap_alloc_fixed_unlocked

heap_alloc_fixed_unlocked:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_fixed_unlocked.asm"
