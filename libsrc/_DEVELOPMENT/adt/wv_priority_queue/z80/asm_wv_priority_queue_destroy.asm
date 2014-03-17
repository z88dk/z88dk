
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void wv_priority_queue_destroy(wv_priority_queue_t *q)
;
; Zero the queue structure and release memory.
;
; ===============================================================

XLIB asm_wv_priority_queue_destroy

LIB asm_b_vector_destroy

defc asm_wv_priority_queue_destroy = asm_b_vector_destroy - 2

   ; enter : hl = priority_queue *
   ;
   ; uses  : af, de, hl
