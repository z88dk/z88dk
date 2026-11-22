
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int ba_priority_queue_pop(ba_priority_queue_t *q)
;
; Pop the highest priority item from the queue.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC asm_ba_priority_queue_pop

EXTERN __array_info, __b_heap_sift_down, error_mc

asm_ba_priority_queue_pop:

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
   
   ld (hl),b
   dec hl
   ld (hl),c                   ; queue.size -= 1

   ex de,hl
   
   ld e,(hl)
   ld d,0                      ; de = item to pop

   push de                     ; save popped item
   push bc                     ; save n = array.size - 1
   
   ld e,l
   ld d,h                      ; de = queue.data
   
   add hl,bc                   ; hl = & queue.data[last_item]
   
   ld c,(hl)                   ; swap(first_item, last_item)
   ld a,(de)
   ld (hl),a
   ld a,c
   ld (de),a
   
   ld c,e
   ld b,d                      ; bc = queue.data
   
   pop hl                      ; hl = n
   
   ; bc = queue.data
   ; hl = n
   ; stack = popped_item
   
   dec bc
   
   ld de,1
   call __b_heap_sift_down
   
   pop hl                      ; hl = popped item
   ret
