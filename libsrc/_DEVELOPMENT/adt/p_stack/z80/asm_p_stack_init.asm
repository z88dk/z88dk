
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_INIT

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_stack_init(void *p)
;
; Create an empty stack in the two bytes of memory provided.
;
; ===============================================================

asm_p_stack_init:

   ; enter : hl = void *p
   ;
   ; exit  : hl = void *p + 2
   ;         de = void *p = p_stack_t *list
   ;
   ; uses  : af, de, hl
