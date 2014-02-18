
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_ALT_INIT

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_queue_init(void *p)
;
; Create an empty queue in the four bytes of memory provided.
;
; ===============================================================

asm_p_queue_init:

   ; enter : hl = void *p
   ;
   ; exit  : hl = void *p + 2
   ;         de = void *p = p_queue_t *q
   ;
   ; uses  : af, de, hl
