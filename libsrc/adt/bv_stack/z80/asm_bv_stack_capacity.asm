
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t bv_stack_capacity(bv_stack_t *s)
;
; Return current capacity of the stack.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC asm_bv_stack_capacity

EXTERN l_readword_hl

defc asm_bv_stack_capacity = l_readword_hl - 4

   ; enter : hl = stack *
   ;
   ; exit  : hl = stack.capacity
   ;
   ; uses  : a, hl
