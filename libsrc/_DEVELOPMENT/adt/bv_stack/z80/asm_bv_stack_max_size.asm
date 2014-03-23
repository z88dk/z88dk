
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t bv_stack_max_size(bv_stack_t *s)
;
; Return maximum size of the stack.
;
; ===============================================================

XLIB asm_bv_stack_max_size

LIB l_readword_hl

asm_bv_stack_max_size:

   jp l_readword_hl - 6

;defc asm_bv_stack_max_size = l_readword_hl - 6

   ; enter : hl = stack *
   ;
   ; exit  : hl = stack.max_size
   ;
   ; uses  : a, hl
