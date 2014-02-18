
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_REMOVE_AFTER

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_stack_pop(p_stack_t *s)
;
; Pop item from stack.
;
; ===============================================================

asm_p_stack_pop:

   ; enter : hl = p_stack_t *s
   ;
   ; exit  : hl = void *item (item popped, 0 if none)
   ;         de = p_stack_t *s
   ;         carry reset if stack was empty
   ;
   ; uses  : af, de, hl
