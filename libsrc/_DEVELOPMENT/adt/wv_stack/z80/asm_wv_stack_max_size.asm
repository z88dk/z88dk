
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t wv_stack_max_size(wv_stack_t *s)
;
; Return maximum size of the stack in words.
;
; ===============================================================

PUBLIC asm_wv_stack_max_size

EXTERN l_readword_2_hl

asm_wv_stack_max_size:

   jp l_readword_2_hl - 6

;defc asm_wv_stack_max_size = l_readword_2_hl - 6

   ; enter : hl = stack *
   ;
   ; exit  : hl = stack.max_size in words
   ;
   ; uses  : a, hl
