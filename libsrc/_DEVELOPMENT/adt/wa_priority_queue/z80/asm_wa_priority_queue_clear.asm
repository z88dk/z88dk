
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void wa_priority_queue_clear(wa_priority_queue_t *q)
;
; Clear the queue to empty.
;
; ===============================================================

XLIB asm_wa_priority_queue_clear

LIB l_zeroword_hl

asm_wa_priority_queue_clear:

   jp l_zeroword_hl - 4

;defc asm_wa_priority_queue_clear = l_zeroword_hl - 4

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = & priority_queue.size
   ;
   ; uses  : hl
