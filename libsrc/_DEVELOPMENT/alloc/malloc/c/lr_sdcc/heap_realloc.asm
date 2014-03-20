
; void *heap_realloc(void *heap, void *p, size_t size)

XDEF heap_realloc

heap_realloc:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_heap_realloc.asm"
