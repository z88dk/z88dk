
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

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC asm_wa_stack_destroy

EXTERN asm_w_array_destroy

defc asm_wa_stack_destroy = asm_w_array_destroy

   ; enter : hl = stack *
   ;
   ; uses  : af, hl
