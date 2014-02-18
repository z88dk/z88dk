
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_INIT

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void p_stack_clear(p_stack_t *s)
;
; Clear the stack to empty.
;
; ===============================================================

asm_p_stack_clear:

   ; enter : hl = p_stack_t *
   ;
   ; exit  : de = p_stack_t *
   ;
   ; uses  : af, de, hl
