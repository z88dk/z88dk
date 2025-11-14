
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int bv_priority_queue_top(bv_priority_queue_t *q)
;
; Return char stored at front of queue.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC asm_bv_priority_queue_top

EXTERN asm_ba_priority_queue_top

defc asm_bv_priority_queue_top = asm_ba_priority_queue_top

   ; enter : hl = priority_queue *
   ;
   ; exit  : de = priority_queue.data
   ;         bc = priority_queue.size in bytes
   ;
   ;         success
   ;
   ;            hl = char at front of priority_queue
   ;            carry reset
   ;
   ;         fail if priority_queue is empty
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
