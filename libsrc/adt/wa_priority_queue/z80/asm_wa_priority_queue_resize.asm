
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int wa_priority_queue_resize(wa_priority_queue_t *q, size_t n)
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
SECTION code_adt_wa_priority_queue

PUBLIC asm_wa_priority_queue_resize

EXTERN __wa_pq_setsize, __w_heap_sift_down, error_mc, error_znc, error_zc

asm_wa_priority_queue_resize:

   ; enter : hl = queue *
   ;         de = n = desired size in words
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

   push de                     ; save n
   
   call __wa_pq_setsize
   jp c, error_mc - 1          ; if n*2 > queue.capacity
   
   ; de = n*2
   ; bc = queue.data
   ; ix = queue.compar
   ; stack = n

   pop hl                      ; hl = n
   
   ld a,l
   and $fe
   or h
   jp z, error_znc             ; if n <= 1 just return

   ex de,hl
   res 0,e
   
   ; de = n = parent_index of last item
   ; hl = n*2 = child_index = index of last item
   ; bc = array
   ; ix = compar
   
   ; the heap array is 1-based
   
   dec bc
   dec bc
   
heapify:

   ld a,d
   or e
   jp z, error_zc              ; if reached the top of the heap
   
   push bc
   push de
   push hl
   
   call __w_heap_sift_down
   
   pop hl
   pop de
   pop bc
   
   dec de
   dec de
   
   jr heapify
