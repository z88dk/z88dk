
; void heap_free(void *heap, void *p)

XDEF heap_free

heap_free:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_heap_free.asm"
