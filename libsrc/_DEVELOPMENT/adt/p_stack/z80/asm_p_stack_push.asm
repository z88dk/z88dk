
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_INSERT_AFTER

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_stack_push(p_stack_t *s, void *item)
;
; Push item onto stack.
;
; ===============================================================

asm_p_stack_push:

   ; enter : hl = p_stack_t *s
   ;         de = void *item
   ;
   ; exit  : hl = void *item
   ;         de = p_stack_t *s
   ;         z flag set if new item is only one in stack
   ;
   ; uses  : af, de, hl
