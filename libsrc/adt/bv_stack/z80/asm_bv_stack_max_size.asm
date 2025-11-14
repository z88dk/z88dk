
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t bv_stack_max_size(bv_stack_t *s)
;
; Return maximum size of the stack.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC asm_bv_stack_max_size

EXTERN l_readword_hl

defc asm_bv_stack_max_size = l_readword_hl - 6

   ; enter : hl = stack *
   ;
   ; exit  : hl = stack.max_size
   ;
   ; uses  : a, hl
