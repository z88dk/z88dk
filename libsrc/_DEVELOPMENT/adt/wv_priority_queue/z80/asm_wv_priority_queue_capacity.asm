
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t wv_priority_queue_capacity(wv_priority_queue_t *q)
;
; Return the amount of space allocated for the queue in words.
;
; ===============================================================

PUBLIC asm_wv_priority_queue_capacity

EXTERN l_readword_2_hl

asm_wv_priority_queue_capacity:

   jp l_readword_2_hl - 6

;defc asm_wv_priority_queue_capacity = l_readword_2_hl - 6

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = capacity in words
   ;
   ; uses  : a, hl
