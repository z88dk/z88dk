
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t wv_stack_max_size(wv_stack_t *s)
;
; Return maximum size of the stack in words.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC asm_wv_stack_max_size

EXTERN l_readword_2_hl

defc asm_wv_stack_max_size = l_readword_2_hl - 6

   ; enter : hl = stack *
   ;
   ; exit  : hl = stack.max_size in words
   ;
   ; uses  : a, hl
