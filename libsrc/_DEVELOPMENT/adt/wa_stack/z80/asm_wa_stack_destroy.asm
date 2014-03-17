
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void wa_stack_destroy(wa_stack_t *s)
;
; Zero the stack structure.
; stack.capacity = 0 ensures no stack operations can be performed.
;
; ===============================================================

XLIB asm_wa_stack_destroy

LIB l_zerostruct6_hl

defc asm_wa_stack_destroy = l_zerostruct6_hl

   ; enter : hl = stack *
   ;
   ; uses  : af, hl
