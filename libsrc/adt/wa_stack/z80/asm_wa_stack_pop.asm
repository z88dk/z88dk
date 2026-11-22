
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *wa_stack_pop(wa_stack_t *s)
;
; Pop item from stack.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC asm_wa_stack_pop

EXTERN asm_w_array_pop_back

defc asm_wa_stack_pop = asm_w_array_pop_back

   ; enter : hl = stack *
   ;
   ; exit  : success
   ;
   ;            hl = last word, popped
   ;            carry reset
   ;
   ;         fail if stack is empty
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
