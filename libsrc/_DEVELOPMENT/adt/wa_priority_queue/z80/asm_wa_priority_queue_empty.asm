
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int wa_priority_queue_empty(wa_priority_queue_t *q)
;
; Return non-zero if the queue is empty.
;
; ===============================================================

PUBLIC asm_wa_priority_queue_empty

EXTERN l_testword_hl

asm_wa_priority_queue_empty:

   jp l_testword_hl - 4

;defc asm_wa_priority_queue_empty = l_testword_hl - 4

   ; enter : hl = priority_queue *
   ;
   ; exit  : if queue is empty
   ;
   ;           hl = 1
   ;           z flag set
   ;
   ;         if queue is not empty
   ;
   ;           hl = 0
   ;           nz flag set
   ;
   ; uses  : af, hl
