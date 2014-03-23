
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t bv_stack_capacity(bv_stack_t *s)
;
; Return current capacity of the stack.
;
; ===============================================================

XLIB asm_bv_stack_capacity

LIB l_readword_hl

asm_bv_stack_capacity:

   jp l_readword_hl - 4

;defc asm_bv_stack_capacity = l_readword_hl - 4

   ; enter : hl = stack *
   ;
   ; exit  : hl = stack.capacity
   ;
   ; uses  : a, hl
