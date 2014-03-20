
; void heap_free(void *heap, void *p)

XDEF heap_free_callee

heap_free_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "../../z80/asm_heap_free.asm"
