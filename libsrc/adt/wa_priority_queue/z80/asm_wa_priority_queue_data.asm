
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *wa_priority_queue_data(wa_priority_queue_t *q)
;
; Return the address of the queue's data, could be 0.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC asm_wa_priority_queue_data

EXTERN l_readword_hl

defc asm_wa_priority_queue_data = l_readword_hl - 2

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = priority_queue.data
   ;
   ; uses  : a, hl
