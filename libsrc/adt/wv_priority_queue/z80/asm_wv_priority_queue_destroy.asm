
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void wv_priority_queue_destroy(wv_priority_queue_t *q)
;
; Zero the queue structure and release memory.
;
; ===============================================================

PUBLIC asm_wv_priority_queue_destroy

EXTERN asm_bv_priority_queue_destroy

defc asm_wv_priority_queue_destroy = asm_bv_priority_queue_destroy

   ; enter : hl = priority_queue *
   ;
   ; uses  : af, de, hl
