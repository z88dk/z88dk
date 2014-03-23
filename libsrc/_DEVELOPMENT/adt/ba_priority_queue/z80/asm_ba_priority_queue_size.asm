
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t ba_priority_queue_size(ba_priority_queue_t *q)
;
; Return the size of the queue in bytes.
;
; ===============================================================

XLIB asm_ba_priority_queue_size

LIB l_readword_hl

asm_ba_priority_queue_size:

   jp l_readword_hl - 4

;defc asm_ba_priority_queue_size = l_readword_hl - 4

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = size in bytes
   ;
   ; uses  : a, hl
