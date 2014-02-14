
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t ba_blockcount(unsigned int queue)
;
; Return number of free blocks in the queue.  O(n).
;
; ===============================================================

XDEF ba_blockcount

ba_blockcount:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_ba_blockcount.asm"
