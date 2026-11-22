
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *wa_priority_queue_pop(wa_priority_queue_t *q)
;
; Pop the highest priority item from the queue.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC asm_wa_priority_queue_pop

EXTERN __array_info, __w_heap_swap, __w_heap_sift_down, error_mc

asm_wa_priority_queue_pop:

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
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, ix

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   
   push de
   pop ix                      ; ix = queue.compare
   
   call __array_info
   jp z, error_mc              ; if no items in queue
   
   ; hl = & queue.size + 1b
   ; de = queue.data
   ; bc = queue.size in bytes
   
   dec bc
   dec bc
   
   ld (hl),b
   dec hl
   ld (hl),c                   ; queue.size -= 2 (one word)

   ex de,hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = item to pop
   dec hl

   push de                     ; save popped item
   push bc                     ; save n*2
   
   ld e,l
   ld d,h                      ; de = queue.data
   
   add hl,bc                   ; hl = & queue.data[last_item

   
   ex de,hl
   call __w_heap_swap          ; swap(first_item, last_item)
   
   ld c,l
   ld b,h                      ; bc = queue.data
   
   pop hl                      ; hl = n*2
   
   ; bc = queue.data
   ; hl = n*2
   ; stack = popped_item
   
   dec bc
   dec bc
   
   ld de,2
   call __w_heap_sift_down
   
   pop hl                      ; hl = popped item
   ret
