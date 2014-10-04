
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t bv_priority_queue_max_size(bv_priority_queue_t *q)
;
; Return maximum size of the priority_queue.
;
; ===============================================================

SECTION seg_code_bv_priority_queue

PUBLIC asm_bv_priority_queue_max_size

EXTERN l_readword_hl

asm_bv_priority_queue_max_size:

defc asm_bv_priority_queue_max_size = l_readword_hl - 8

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = priority_queue.max_size
   ;
   ; uses  : a, hl
