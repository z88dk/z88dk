
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int bv_priority_queue_push(bv_priority_queue_t *q, int c)
;
; Push item into the priority queue.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC asm_bv_priority_queue_push

EXTERN asm_b_vector_append, asm0_ba_priority_queue_push, error_mc

asm_bv_priority_queue_push:

   ; enter : hl = priority_queue *
   ;         bc = int c
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail if max_size exceeded
   ;
   ;            hl = -1
   ;            carry set
   ;
   ;         fail if insufficient memory or lock not acquired
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, ix

   push hl                     ; save queue *
   
   inc hl
   inc hl                      ; hl = & queue.b_vector
   
   call asm_b_vector_append    ; append char
   jp nc, asm0_ba_priority_queue_push

   jp error_mc - 1             ; if vector could not be grown
