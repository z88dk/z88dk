
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t bv_priority_queue_capacity(bv_priority_queue_t *q)
;
; Return the amount of space allocated for the queue in bytes.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC asm_bv_priority_queue_capacity

EXTERN l_readword_hl

defc asm_bv_priority_queue_capacity = l_readword_hl - 6

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = capacity in bytes
   ;
   ; uses  : a, hl
