
; void heap_free(void *heap, void *p)

XDEF heap_free

heap_free:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_heap_free.asm"
