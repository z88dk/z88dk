
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_SIZE

; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t p_stack_size(p_stack_t *s)
;
; Return number of items in stack.  O(n).
;
; ===============================================================

asm_p_stack_size:

   ; enter : hl = p_stack_t *s
   ;
   ; exit  : hl = number of items in list
   ;
   ; uses  : af, de, hl
