
; void *heap_init(void *heap, size_t size)

PUBLIC _heap_init

_heap_init:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_init.asm"
