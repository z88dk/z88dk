
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int ba_priority_queue_resize(ba_priority_queue_t *q, size_t n)
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

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC asm_ba_priority_queue_resize

EXTERN __ba_pq_setsize, __b_heap_sift_down, error_mc, error_znc

asm_ba_priority_queue_resize:

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
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, ix

   call __ba_pq_setsize
   jp c, error_mc              ; if n > queue.capacity
   
   ; de = n
   ; bc = queue.data
   ; ix = queue.compar
   
   ld a,e
   and $fe
   or d
   jp z, error_znc             ; if n <= 1 just return

   ld l,e
   ld h,d                      ; hl = n = child_index
   
   srl d
   rr e                        ; de = n/2 = parent_index

   ; de = n/2 = parent_index of last item
   ; hl = n = child_index = index of last item
   ; bc = array
   ; ix = compar
   
   ; the heap array is 1-based
   
   dec bc
   
heapify:

   ld a,d
   or e
   jp z, error_znc             ; if reached the top of the heap
   
   push bc
   push de
   push hl
   
   call __b_heap_sift_down
   
   pop hl
   pop de
   pop bc
   
   dec de
   jr heapify
