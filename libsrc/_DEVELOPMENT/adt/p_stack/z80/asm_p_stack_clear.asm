
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void p_stack_clear(p_stack_t *s)
;
; Clear the stack to empty.
;
; ===============================================================

XLIB asm_p_stack_clear

LIB asm_p_forward_list_init

asm_p_stack_clear:

   jp asm_p_forward_list_init

;defc asm_p_stack_clear = asm_p_forward_list_init

   ; enter : hl = p_stack_t *
   ;
   ; exit  : de = p_stack_t *
   ;
   ; uses  : af, de, hl
