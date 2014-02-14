
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void heap_free_unlocked(void *heap, void *p)
;
; Deallocate memory previously allocated at p from the heap.
;
; If p == 0, function returns without performing an action.
;
; ===============================================================

XDEF heap_free_unlocked

heap_free_unlocked:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_heap_free_unlocked.asm"
