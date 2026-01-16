
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void wv_stack_clear(wv_stack_t *s)
;
; Clear the stack to empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC asm_wv_stack_clear

EXTERN l_zeroword_hl

defc asm_wv_stack_clear = l_zeroword_hl - 2

   ; enter : hl = stack *
   ;
   ; exit  : hl = & stack.size
   ;
   ; uses  : hl
