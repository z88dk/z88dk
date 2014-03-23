
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t ba_priority_queue_capacity(ba_priority_queue_t *q)
;
; Return the amount of space allocated for the queue in bytes.
;
; ===============================================================

XLIB asm_ba_priority_queue_capacity

LIB l_readword_hl

asm_ba_priority_queue_capacity:

   jp l_readword_hl - 6

;defc asm_ba_priority_queue_capacity = l_readword_hl - 6

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = capacity in bytes
   ;
   ; uses  : a, hl
