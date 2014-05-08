
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void bv_priority_queue_clear(bv_priority_queue_t *q)
;
; Clear the queue to empty.
;
; ===============================================================

PUBLIC asm_bv_priority_queue_clear

EXTERN l_zeroword_hl

asm_bv_priority_queue_clear:

   jp l_zeroword_hl - 4

;defc asm_bv_priority_queue_clear = l_zeroword_hl - 4

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = & priority_queue.size
   ;
   ; uses  : hl
