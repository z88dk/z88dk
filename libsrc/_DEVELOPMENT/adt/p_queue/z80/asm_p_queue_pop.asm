
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_ALT_POP_FRONT

; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *p_queue_pop(p_queue_t *q)
;
; Pop item from queue.
;
; ===============================================================

asm_p_queue_pop:

   ; enter : hl = p_queue_t *q
   ;
   ; exit  : hl = void *item (item popped, 0 if none)
   ;         de = p_queue_t *q
   ;         carry reset if stack was empty
   ;
   ; uses  : af, de, hl
