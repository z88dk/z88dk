
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *p_queue_front(p_queue_t *q)
;
; Return item at front of queue without removing it.
;
; ===============================================================

XLIB asm_p_queue_front

LIB asm_p_forward_list_front

defc asm_p_queue_front = asm_p_forward_list_front

   ; enter : hl = queue *
   ;
   ; exit  : success
   ;
   ;            hl = void *item (item at front)
   ;            carry reset
   ;
   ;         fail if list is empty
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, hl
