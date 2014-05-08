
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t wa_stack_size(wa_stack_t *s)
;
; Return number of words in stack.
;
; ===============================================================

PUBLIC asm_wa_stack_size

EXTERN l_readword_2_hl

asm_wa_stack_size:

   jp l_readword_2_hl - 2

;defc asm_wa_stack_size = l_readword_2_hl - 2

   ; enter : hl = stack *
   ;
   ; exit  : hl = number of words in stack
   ;
   ; uses  : a, hl
