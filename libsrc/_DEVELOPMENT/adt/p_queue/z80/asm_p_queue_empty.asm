
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_EMPTY

; ===============================================================
; Feb 2014
; ===============================================================
; 
; int p_queue_empty(p_queue_t *q)
;
; Return true (non-zero) if stack is empty.
;
; ===============================================================

asm_p_queue_empty:

   ; enter : hl = p_queue_t *
   ;
   ; exit  : if stack is empty
   ;
   ;           hl = 1
   ;           z flag set
   ;
   ;         if stack is not empty
   ;
   ;           hl = 0
   ;           nz flag set
   ;
   ; uses  : af, hl
