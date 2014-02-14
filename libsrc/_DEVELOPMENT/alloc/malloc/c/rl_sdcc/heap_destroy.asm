
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_destroy(void *heap)
;
; Destroy the mutex associated with the heap.
;
; ===============================================================

XDEF heap_destroy

heap_destroy:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_heap_destroy.asm"
