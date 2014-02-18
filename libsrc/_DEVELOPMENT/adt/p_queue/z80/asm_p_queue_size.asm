
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_SIZE

; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t p_queue_size(p_queue_t *q)
;
; Return number of items in queue.  O(n).
;
; ===============================================================

asm_p_queue_size:

   ; enter : hl = p_queue_t *q
   ;
   ; exit  : hl = number of items in queue
   ;
   ; uses  : af, de, hl
