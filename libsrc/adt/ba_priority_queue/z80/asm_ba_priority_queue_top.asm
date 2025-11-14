
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int ba_priority_queue_top(ba_priority_queue_t *q)
;
; Return char stored at front of queue.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC asm_ba_priority_queue_top

EXTERN asm_b_array_front

asm_ba_priority_queue_top:

   inc hl
   inc hl

   jp asm_b_array_front

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
   ;            carry se
   ;
   ; uses  : af, bc, de, hl
