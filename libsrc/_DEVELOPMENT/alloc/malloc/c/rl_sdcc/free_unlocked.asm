
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void free_unlocked(void *p)
;
; Deallocate memory previously allocated at p from the thread's
; default heap.
;
; If p == 0, function returns without performing an action.
;
; ===============================================================

XDEF free_unlocked

free_unlocked:

   INCLUDE "../../z80/asm_free_unlocked.asm"
