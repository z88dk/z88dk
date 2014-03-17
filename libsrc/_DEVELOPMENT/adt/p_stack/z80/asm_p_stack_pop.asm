
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_stack_pop(p_stack_t *s)
;
; Pop item from stack.
;
; ===============================================================

XLIB asm_p_stack_pop

LIB asm_p_forward_list_remove_after

defc asm_p_stack_pop = asm_p_forward_list_remove_after

   ; enter : hl = stack *
   ;
   ; exit  : de = stack *
   ;
   ;         success
   ;
   ;            hl = void *item (item removed)
   ;            z flag set if stack is now empty
   ;            carry reset
   ;
   ;         fail if the stack is empty
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, de, hl
