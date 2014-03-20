
; void *heap_init(void *heap, size_t size)

XDEF heap_init

heap_init:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_heap_init.asm"
