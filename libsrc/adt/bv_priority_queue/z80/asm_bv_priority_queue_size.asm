
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t bv_priority_queue_size(bv_priority_queue_t *q)
;
; Return the size of the queue in bytes.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC asm_bv_priority_queue_size

EXTERN l_readword_hl

defc asm_bv_priority_queue_size = l_readword_hl - 4

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = size in bytes
   ;
   ; uses  : a, hl
