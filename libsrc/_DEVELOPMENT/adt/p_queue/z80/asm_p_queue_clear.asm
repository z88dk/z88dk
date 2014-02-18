
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_ALT_INIT

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void p_queue_clear(p_queue_t *q)
;
; Clear the stack to empty.
;
; ===============================================================

asm_p_queue_clear:

   ; enter : hl = p_queue_t *
   ;
   ; exit  : de = p_queue_t *
   ;
   ; uses  : af, de, hl
