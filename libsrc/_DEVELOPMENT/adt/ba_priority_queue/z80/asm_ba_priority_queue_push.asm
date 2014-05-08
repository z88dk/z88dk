
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int ba_priority_queue_push(ba_priority_queue_t *q, int c)
;
; Push item into the priority queue.
;
; ===============================================================

PUBLIC asm_ba_priority_queue_push
PUBLIC asm1_ba_priority_queue_push

EXTERN asm_b_array_append_block, __b_heap_sift_up, error_enomem_mc

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
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl, ix

   push hl                     ; save queue *
   push bc                     ; save item
   
   inc hl
   inc hl                      ; hl = & queue.b_array
   
   ld de,1
   call asm_b_array_append_block

   pop bc                      ; bc = item
   jp c, error_enomem_mc - 1   ; if no room to add item

asm1_ba_priority_queue_push:

   ld (hl),c                   ; append item to queue

   ; de = index of last item in bytes
   ; hl = & queue.data[last_item]
   ; stack = queue *
   
   ex (sp),hl                  ; hl = queue *
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = compare function
   inc hl
   
   ld ixl,c
   ld ixh,b                    ; ix = compare function
   
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
