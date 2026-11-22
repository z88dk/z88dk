
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void bv_priority_queue_destroy(bv_priority_queue_t *q)
;
; Zero the queue structure and release memory.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC asm_bv_priority_queue_destroy

EXTERN asm_b_vector_destroy

asm_bv_priority_queue_destroy:

   inc hl
   inc hl
   
   jp asm_b_vector_destroy

   ; enter : hl = priority_queue *
   ;
   ; uses  : af, de, hl
