
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t wv_priority_queue_max_size(wv_priority_queue_t *q)
;
; Return maximum size of the priority_queue.
;
; ===============================================================

PUBLIC asm_wv_priority_queue_max_size

EXTERN l_readword_2_hl

asm_wv_priority_queue_max_size:

   jp l_readword_2_hl - 8

;defc asm_wv_priority_queue_max_size = l_readword_2_hl - 8

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = priority_queue.max_size
   ;
   ; uses  : a, hl
