
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int bv_priority_queue_reserve(bv_priority_queue_t *q, size_t n)
;
; Allocate at least n bytes for the priority_queue.
;
; If the priority_queue is already larger, do nothing.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC asm_bv_priority_queue_reserve

EXTERN asm_b_vector_reserve

asm_bv_priority_queue_reserve:

   inc hl
   inc hl
   
   jp asm_b_vector_reserve

   ; enter : hl = priority_queue *
   ;         bc = n
   ;
   ; exit  : bc = n
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
