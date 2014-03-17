
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int bv_priority_queue_push(bv_priority_queue_t *q, int c)
;
; Push item into the priority queue.
;
; ===============================================================

XLIB asm_bv_priority_queue_push

LIB asm_b_vector_append_block, asm1_ba_priority_queue_push, error_mc

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
   ;            carry set, errno = EINVAL
   ;
   ;         fail if insufficient memory or lock not acquired
   ;
   ;            hl = -1
   ;            carry set, errno = ENOMEM or ENOLCK
   ;
   ; uses  : af, bc, de, hl, ix

   push hl                     ; save queue *
   push bc                     ; save item
   
   inc hl
   inc hl                      ; hl = & queue.b_vector
   
   ld de,1
   call asm_b_vector_append_block

   pop bc                      ; bc = item
   jp nc, asm1_ba_priority_queue_push
   
   jp error_mc - 1             ; if vector could not be grown
