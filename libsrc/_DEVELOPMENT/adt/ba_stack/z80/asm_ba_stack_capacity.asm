
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t ba_stack_capacity(ba_stack_t *s)
;
; Return capacity of the stack.
;
; ===============================================================

PUBLIC asm_ba_stack_capacity

EXTERN l_readword_hl

asm_ba_stack_capacity:

   jp l_readword_hl - 4

;defc asm_ba_stack_capacity = l_readword_hl - 4

   ; enter : hl = stack *
   ;
   ; exit  : hl = stack.capacity
   ;
   ; uses  : a, hl
