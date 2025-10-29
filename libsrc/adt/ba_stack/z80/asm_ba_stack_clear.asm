
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void ba_stack_clear(ba_stack_t *s)
;
; Clear the stack to empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC asm_ba_stack_clear

EXTERN l_zeroword_hl

defc asm_ba_stack_clear = l_zeroword_hl - 2

   ; enter : hl = stack *
   ;
   ; exit  : hl = & stack.size
   ;
   ; uses  : hl
