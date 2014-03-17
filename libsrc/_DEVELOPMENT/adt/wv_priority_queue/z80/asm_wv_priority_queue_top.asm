
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *wv_priority_queue_top(wv_priority_queue_t *q)
;
; Return word stored at front of queue.
;
; ===============================================================

XLIB asm_wv_priority_queue_top

LIB asm_w_array_front

defc asm_wv_priority_queue_top = asm_w_array_front - 2

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
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
