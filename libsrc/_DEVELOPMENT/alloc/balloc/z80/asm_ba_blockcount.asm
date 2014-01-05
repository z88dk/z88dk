*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FORWARD_LIST_SIZE()

; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t ba_blockcount(forward_list *q)
;
; Return number of free blocks in the queue.  O(n).
;
; ===============================================================

asm_ba_blockcount:

   ; enter : hl = forward_list *q
   ;
   ; exit  : hl = number of available blocks
   ;
   ; uses  : af, de, hl
