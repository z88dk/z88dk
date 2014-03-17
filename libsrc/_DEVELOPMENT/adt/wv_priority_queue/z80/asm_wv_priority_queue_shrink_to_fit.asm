
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int wv_priority_queue_shrink_to_fit(wv_priority_queue_t *q)
;
; Release any excess memory allocated for the queue.
;
; After calling, priority_queue.capacity == priority_queue.size
;
; ===============================================================

XLIB asm_wv_priority_queue_shrink_to_fit

LIB asm_b_vector_shrink_to_fit

defc asm_wv_priority_queue_shrink_to_fit = asm_b_vector_shrink_to_fit - 2

   ; enter : hl = priority_queue *
   ;
   ; exit  : success
   ;
   ;            hl = -1
   ;            carry reset
   ;
   ;         fail on realloc not getting lock
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
