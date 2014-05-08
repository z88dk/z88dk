
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void ba_stack_destroy(ba_stack_t *s)
;
; Zero the stack structure.
; stack.capacity = 0 ensures no stack operations can be performed.
;
; ===============================================================

PUBLIC asm_ba_stack_destroy

EXTERN asm_b_array_destroy

asm_ba_stack_destroy:

   jp asm_b_array_destroy

;defc asm_ba_stack_destroy = asm_b_array_destroy

   ; enter : hl = stack *
   ;
   ; uses  : af, hl
