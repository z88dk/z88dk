
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int bv_priority_queue_pop(bv_priority_queue_t *q)
;
; Pop the highest priority item from the queue.
;
; ===============================================================

XLIB asm_bv_priority_queue_pop

LIB asm_ba_priority_queue_pop

asm_bv_priority_queue_pop:

   jp asm_ba_priority_queue_pop

;defc asm_bv_priority_queue_pop = asm_ba_priority_queue_pop

   ; enter : hl = queue *
   ;
   ; exit  : success
   ;
   ;            hl = popped item
   ;            carry reset
   ;
   ;         fail if queue is empty
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl, ix
