
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t ba_stack_size(ba_stack_t *s)
;
; Return number of items in stack.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC asm_ba_stack_size

EXTERN l_readword_hl

defc asm_ba_stack_size = l_readword_hl - 2

   ; enter : hl = stack *
   ;
   ; exit  : hl = number of items in stack
   ;
   ; uses  : a, hl
