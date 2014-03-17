
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t bv_priority_queue_max_size(bv_priority_queue_t *q)
;
; Return maximum size of the priority_queue.
;
; ===============================================================

XLIB asm_bv_priority_queue_max_size

LIB l_readword_hl

defc asm_bv_priority_queue_max_size = l_readword_hl - 8

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = priority_queue.max_size
   ;
   ; uses  : a, hl
