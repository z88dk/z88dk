
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_stack_pop(p_stack_t *s)
;
; Pop item from stack.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC asm_p_stack_pop

EXTERN asm_p_forward_list_remove_after

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
   ;            carry set
   ;
   ; uses  : af, de, hl
