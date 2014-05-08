
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t bv_stack_size(bv_stack_t *s)
;
; Return number of items in stack.
;
; ===============================================================

PUBLIC asm_bv_stack_size

EXTERN l_readword_hl

asm_bv_stack_size:

   jp l_readword_hl - 2

;defc asm_bv_stack_size = l_readword_hl - 2

   ; enter : hl = stack *
   ;
   ; exit  : hl = number of items in stack
   ;
   ; uses  : a, hl
