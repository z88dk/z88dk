
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void wv_priority_queue_clear(wv_priority_queue_t *q)
;
; Clear the queue to empty.
;
; ===============================================================

XLIB asm_wv_priority_queue_clear

LIB l_zeroword_hl

asm_wv_priority_queue_clear:

   jp l_zeroword_hl - 4

;defc asm_wv_priority_queue_clear = l_zeroword_hl - 4

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = & priority_queue.size
   ;
   ; uses  : hl
