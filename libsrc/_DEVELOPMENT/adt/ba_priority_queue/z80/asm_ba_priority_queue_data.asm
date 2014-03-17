
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *ba_priority_queue_data(ba_priority_queue_t *q)
;
; Return the address of the queue's data, could be 0.
;
; ===============================================================

XLIB asm_ba_priority_queue_data

LIB l_readword_hl

defc asm_ba_priority_queue_data = l_readword_hl - 2

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = priority_queue.data
   ;
   ; uses  : a, hl
