
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t wv_stack_size(wv_stack_t *s)
;
; Return number of words in stack.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC asm_wv_stack_size

EXTERN l_readword_2_hl

defc asm_wv_stack_size = l_readword_2_hl - 2

   ; enter : hl = stack *
   ;
   ; exit  : hl = number of words in stack
   ;
   ; uses  : a, hl
