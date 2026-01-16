
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t ba_stack_capacity(ba_stack_t *s)
;
; Return capacity of the stack.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC asm_ba_stack_capacity

EXTERN l_readword_hl

defc asm_ba_stack_capacity = l_readword_hl - 4

   ; enter : hl = stack *
   ;
   ; exit  : hl = stack.capacity
   ;
   ; uses  : a, hl
