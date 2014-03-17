
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t wv_stack_capacity(wv_stack_t *s)
;
; Return capacity of the stack in words.
;
; ===============================================================

XLIB asm_wv_stack_capacity

LIB l_readword_2_hl

defc asm_wv_stack_capacity = l_readword_2_hl - 4

   ; enter : hl = stack *
   ;
   ; exit  : hl = stack.capacity in words
   ;
   ; uses  : a, hl
