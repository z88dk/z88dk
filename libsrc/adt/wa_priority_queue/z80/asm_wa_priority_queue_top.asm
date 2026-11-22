
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *wa_priority_queue_top(wa_priority_queue_t *q)
;
; Return word stored at front of queue.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC asm_wa_priority_queue_top

EXTERN asm_w_array_front

asm_wa_priority_queue_top:

   inc hl
   inc hl
   
   jp asm_w_array_front

   ; enter : hl = priority_queue *
   ;
   ; exit  : de = priority_queue.data
   ;         bc = priority_queue.size in bytes
   ;
   ;         success
   ;
   ;            hl = word at front of priority_queue
   ;            carry reset
   ;
   ;         fail if priority_queue is empty
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
