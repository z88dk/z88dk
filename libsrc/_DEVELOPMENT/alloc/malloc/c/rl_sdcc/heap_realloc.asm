
; void *heap_realloc(void *heap, void *p, size_t size)

XDEF heap_realloc

heap_realloc:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_heap_realloc.asm"
