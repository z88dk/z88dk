
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void bv_stack_clear(bv_stack_t *s)
;
; Clear the stack to empty.
;
; ===============================================================

PUBLIC asm_bv_stack_clear

EXTERN l_zeroword_hl

asm_bv_stack_clear:

   jp l_zeroword_hl - 2

;defc asm_bv_stack_clear = l_zeroword_hl - 2

   ; enter : hl = stack *
   ;
   ; exit  : hl = & stack.size
   ;
   ; uses  : hl
