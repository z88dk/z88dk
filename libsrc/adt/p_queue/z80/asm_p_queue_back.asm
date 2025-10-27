
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *p_queue_back(p_queue_t *q)
;
; Return item at back of queue without removing it from the queue.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC asm_p_queue_back

EXTERN asm_p_forward_list_alt_back

defc asm_p_queue_back = asm_p_forward_list_alt_back

   ; enter : hl = queue *
   ;
   ; exit  : success
   ;
   ;            hl = void *item (last item in list)
   ;            carry reset
   ;
   ;         fail if list is empty
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, hl
