
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_ALT_PUSH_BACK

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_queue_push(p_queue_t *q, void *item)
;
; Push item into queue.
;
; ===============================================================

asm_p_queue_push:

   ; enter : hl = p_queue_t *q
   ;         de = void *item
   ;
   ; exit  : hl = void *item
   ;         de = p_queue_t *q
   ;         z flag set if new item is only one in queue
   ;
   ; uses  : af, de, hl
