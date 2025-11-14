
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int ba_priority_queue_push(ba_priority_queue_t *q, int c)
;
; Push item into the priority queue.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC asm_ba_priority_queue_push, asm0_ba_priority_queue_push

EXTERN asm_b_array_append, __b_heap_sift_up, error_mc

asm_ba_priority_queue_push:

   ; enter : hl = priority_queue *
   ;         bc = int c
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
   
   call asm_b_array_append
   jp c, error_mc - 1          ; if no room to add item

asm0_ba_priority_queue_push:

   ; hl = idx of appended char
   ; de = & queue.data[idx]
   ; stack = queue *
   
   ex de,hl
   ex (sp),hl                  ; hl = queue *
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = compare function
   inc hl
   
   push bc
   pop ix                      ; ix = compare function
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = queue.data
   
   pop hl                      ; hl = & queue.data[last_item]

   ; de = index of last_item in bytes
   ; hl = & queue.data[last_item]
   ; bc = queue.data
   ; ix = compare

   ; heap functions written for 1-based arrays
   
   dec bc
   inc de
   
   jp __b_heap_sift_up
