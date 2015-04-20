
; void *heap_init_callee(void *heap, size_t size)

SECTION code_alloc_malloc

PUBLIC _heap_init_callee

_heap_init_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_init.asm"
