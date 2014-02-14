
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void free(void *p)
;
; Deallocate memory previously allocated at p from the thread's
; default heap.
;
; If p == 0, function returns without performing an action.
;
; ===============================================================

XDEF free

free:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_free.asm"
