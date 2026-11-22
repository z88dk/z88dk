
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int ba_stack_pop(ba_stack_t *s)
;
; Pop item from stack.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC asm_ba_stack_pop

EXTERN asm_b_array_pop_back

defc asm_ba_stack_pop = asm_b_array_pop_back

   ; enter : hl = stack *
   ;
   ; exit  : success
   ;
   ;            hl = last char, popped
   ;            carry reset
   ;
   ;         fail if stack is empty
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
