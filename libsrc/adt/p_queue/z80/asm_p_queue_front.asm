
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *p_queue_front(p_queue_t *q)
;
; Return item at front of queue without removing it.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC asm_p_queue_front

EXTERN asm_p_forward_list_front

defc asm_p_queue_front = asm_p_forward_list_front

   ; enter : hl = queue *
   ;
   ; exit  : success
   ;
   ;            hl = void *item (item at front)
   ;            nz flag set
   ;
   ;         fail if list is empty
   ;
   ;            hl = 0
   ;            z flag set
   ;
   ; uses  : af, hl
