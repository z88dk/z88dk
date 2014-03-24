
; void *heap_init(void *heap, size_t size)

XDEF heap_init

heap_init:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_init.asm"
