
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *wa_stack_top(wa_stack_t *s)
;
; Return char at top of stack without removing it.
; If the stack is empty, return -1.
;
; ===============================================================

XLIB asm_wa_stack_top

LIB asm_w_array_back

defc asm_wa_stack_top = asm_w_array_back

   ; enter : hl = stack *
   ;
   ; exit  : success
   ;
   ;            de = & last word in stack
   ;            hl = last word in stack
   ;            carry reset
   ;
   ;         fail if stack is empty
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
