
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t wa_stack_capacity(wa_stack_t *s)
;
; Return capacity of the stack in words.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC asm_wa_stack_capacity

EXTERN l_readword_2_hl

defc asm_wa_stack_capacity = l_readword_2_hl - 4

   ; enter : hl = stack *
   ;
   ; exit  : hl = stack.capacity in words
   ;
   ; uses  : a, hl
