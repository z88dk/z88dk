
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

XDEF heap_free_callee

heap_free_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "../../z80/asm_heap_free.asm"
