
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void wa_stack_clear(wa_stack_t *s)
;
; Clear the stack to empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC asm_wa_stack_clear

EXTERN l_zeroword_hl

defc asm_wa_stack_clear = l_zeroword_hl - 2

   ; enter : hl = stack *
   ;
   ; exit  : hl = & stack.size
   ;
   ; uses  : hl
