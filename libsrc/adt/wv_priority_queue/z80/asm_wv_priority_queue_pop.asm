
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *wv_priority_queue_pop(wv_priority_queue_t *q)
;
; Pop the highest priority item from the queue.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC asm_wv_priority_queue_pop

EXTERN asm_wa_priority_queue_pop

defc asm_wv_priority_queue_pop = asm_wa_priority_queue_pop

   ; enter : hl = queue *
   ;
   ; exit  : success
   ;
   ;            hl = popped item
   ;            carry reset
   ;
   ;         fail if queue is empty
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, ix
