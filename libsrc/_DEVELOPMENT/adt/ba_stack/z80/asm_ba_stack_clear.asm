
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void ba_stack_clear(ba_stack_t *s)
;
; Clear the stack to empty.
;
; ===============================================================

XLIB asm_ba_stack_clear

LIB l_zeroword_hl

defc asm_ba_stack_clear = l_zeroword_hl - 2

   ; enter : hl = stack *
   ;
   ; exit  : hl = & stack.size
   ;
   ; uses  : hl
