
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void heap_free(void *heap, void *p)
;
; Deallocate memory previously allocated at p from the heap.
;
; If p == 0, function returns without performing an action.
;
; ===============================================================

XDEF heap_free

heap_free:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_heap_free.asm"
