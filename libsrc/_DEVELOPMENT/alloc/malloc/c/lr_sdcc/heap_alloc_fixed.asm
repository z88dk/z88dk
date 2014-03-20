
; void *heap_alloc_fixed(void *heap, void *p, size_t size)

XDEF heap_alloc_fixed

heap_alloc_fixed:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_heap_alloc_fixed.asm"
