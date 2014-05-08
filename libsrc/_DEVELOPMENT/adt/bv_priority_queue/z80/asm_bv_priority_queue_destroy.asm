
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void bv_priority_queue_destroy(bv_priority_queue_t *q)
;
; Zero the queue structure and release memory.
;
; ===============================================================

PUBLIC asm_bv_priority_queue_destroy

EXTERN asm_b_vector_destroy

asm_bv_priority_queue_destroy:

   jp asm_b_vector_destroy - 2

;defc asm_bv_priority_queue_destroy = asm_b_vector_destroy - 2

   ; enter : hl = priority_queue *
   ;
   ; uses  : af, de, hl
