
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_stack_push(p_stack_t *s, void *item)
;
; Push item onto stack.
;
; ===============================================================

XLIB asm_p_stack_push

LIB asm_p_forward_list_insert_after

asm_p_stack_push:

   jp asm_p_forward_list_insert_after

;defc asm_p_stack_push = asm_p_forward_list_insert_after

   ; enter : hl = stack *
   ;         de = void *item
   ;
   ; exit  : hl = void *item
   ;         de = stack *
   ;         z flag set if item is the only one in stack
   ;
   ; uses  : af, de, hl
