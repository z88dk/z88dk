
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void bv_stack_clear(bv_stack_t *s)
;
; Clear the stack to empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC asm_bv_stack_clear

EXTERN l_zeroword_hl

defc asm_bv_stack_clear = l_zeroword_hl - 2

   ; enter : hl = stack *
   ;
   ; exit  : hl = & stack.size
   ;
   ; uses  : hl
