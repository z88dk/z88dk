
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *p_stack_top(p_stack_t *s)
;
; Return item at top of stack without removing it.
;
; ===============================================================

XLIB asm_p_stack_top

LIB asm_p_forward_list_front

defc asm_p_stack_top = asm_p_forward_list_front

   ; enter : hl = stack *
   ;
   ; exit  : success
   ;
   ;            hl = void *item (item at front)
   ;            carry reset
   ;
   ;         fail if stack is empty
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, hl
