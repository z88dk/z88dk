
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int wv_priority_queue_reserve(wv_priority_queue_t *q, size_t n)
;
; Allocate at least n words for the priority_queue.
;
; If the priority_queue is already larger, do nothing.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC asm_wv_priority_queue_reserve

EXTERN asm_w_vector_reserve

asm_wv_priority_queue_reserve:

   inc hl
   inc hl
   
   jp asm_w_vector_reserve

   ; enter : hl = priority_queue *
   ;         bc = n
   ;
   ; exit  : bc = n * 2 bytes
   ;         de = & priority_queue.capacity + 1b
   ;
   ;         success
   ;
   ;            hl = -1
   ;            carry reset
   ;
   ;         fail if max_size exceeded
   ;
   ;            hl = 0
   ;            carry set
   ;
   ;         fail if realloc failed
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, de, hl
