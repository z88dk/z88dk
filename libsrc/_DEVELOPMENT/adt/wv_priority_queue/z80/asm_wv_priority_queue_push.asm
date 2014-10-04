
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int wv_priority_queue_push(wv_priority_queue_t *q, void *item)
;
; Push item into the priority queue.
;
; ===============================================================

SECTION seg_code_wv_priority_queue

PUBLIC asm_wv_priority_queue_push

EXTERN asm_b_vector_append_block, asm1_wa_priority_queue_push, error_mc

asm_wv_priority_queue_push:

   ; enter : hl = priority_queue *
   ;         bc = item
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail if queue full
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, ix

   push hl                     ; save queue *
   push bc                     ; save item
   
   inc hl
   inc hl                      ; hl = & queue.w_vector
   
   ld de,2
   call asm_b_vector_append_block
   
   pop bc                      ; bc = item
   jp nc, asm1_wa_priority_queue_push
   
   jp error_mc - 1             ; if no room to add item
