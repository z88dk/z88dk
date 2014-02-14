
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *ba_alloc(unsigned int queue)
;
; Allocate a block of memory from the front of the queue.
;
; ===============================================================

XDEF ba_alloc

ba_alloc:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_ba_alloc.asm"
