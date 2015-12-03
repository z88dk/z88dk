
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

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC asm_wv_priority_queue_shrink_to_fit

EXTERN asm_bv_priority_queue_shrink_to_fit

defc asm_wv_priority_queue_shrink_to_fit = asm_bv_priority_queue_shrink_to_fit

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
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
