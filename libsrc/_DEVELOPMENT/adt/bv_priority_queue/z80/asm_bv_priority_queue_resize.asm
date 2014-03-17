
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int bv_priority_queue_resize(bv_priority_queue_t *q, size_t n)
;
; Attempt to resize the queue to n bytes.
;
; If n <= queue.capacity, the array owned by the queue will
; have its size set to n.
;
; This resize operation does not change the contents of the queue
; array; instead it is assumed the queue array of the new size
; contains all valid data, possibly not in heap order.  The
; resize operation therefore triggers a heapify to make sure
; the queue is kept in heap order.  This means the caller can
; place data directly into the queue's array and then call this
; function to have it ordered into a heap.
;
; ===============================================================

XLIB bv_priority_queue_resize

LIB ba_priority_queue_resize

defc bv_priority_queue_resize = ba_priority_queue_resize

   ; enter : hl = queue *
   ;         de = n = desired size in bytes
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail if queue is too small
   ;
   ;            hl = -1
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl, ix
