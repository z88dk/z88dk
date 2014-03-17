
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t wa_stack_size(wa_stack_t *s)
;
; Return number of words in stack.
;
; ===============================================================

XLIB asm_wa_stack_size

LIB l_readword_2_hl

defc asm_wa_stack_size = l_readword_2_hl - 2

   ; enter : hl = stack *
   ;
   ; exit  : hl = number of words in stack
   ;
   ; uses  : a, hl
