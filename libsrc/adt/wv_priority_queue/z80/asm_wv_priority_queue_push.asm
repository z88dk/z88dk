
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int wv_priority_queue_push(wv_priority_queue_t *q, void *item)
;
; Push item into the priority queue.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC asm_wv_priority_queue_push

EXTERN asm_w_vector_append, asm0_wa_priority_queue_push, error_mc

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
   
   call asm_w_vector_append    ; append item
   jp nc, asm0_wa_priority_queue_push
   
   jp error_mc - 1             ; if append failed
