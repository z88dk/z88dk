
; void *heap_alloc_fixed_unlocked(void *heap, void *p, size_t size)

PUBLIC _heap_alloc_fixed_unlocked

_heap_alloc_fixed_unlocked:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_fixed_unlocked.asm"
