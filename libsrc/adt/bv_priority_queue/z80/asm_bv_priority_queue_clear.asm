
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void bv_priority_queue_clear(bv_priority_queue_t *q)
;
; Clear the queue to empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC asm_bv_priority_queue_clear

EXTERN l_zeroword_hl

defc asm_bv_priority_queue_clear = l_zeroword_hl - 4

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = & priority_queue.size
   ;
   ; uses  : hl
