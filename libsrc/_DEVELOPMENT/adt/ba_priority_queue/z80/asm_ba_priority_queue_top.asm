
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int ba_priority_queue_top(ba_priority_queue_t *q)
;
; Return char stored at front of queue.
;
; ===============================================================

XLIB asm_ba_priority_queue_top

LIB asm_b_array_front

asm_ba_priority_queue_top:

   jp asm_b_array_front - 2

;defc asm_ba_priority_queue_top = asm_b_array_front - 2

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
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
