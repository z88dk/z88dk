
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void bv_priority_queue_clear(bv_priority_queue_t *q)
;
; Clear the queue to empty.
;
; ===============================================================

XLIB asm_bv_priority_queue_clear

LIB l_zeroword_hl

defc asm_bv_priority_queue_clear = l_zeroword_hl - 4

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = & priority_queue.size
   ;
   ; uses  : hl
