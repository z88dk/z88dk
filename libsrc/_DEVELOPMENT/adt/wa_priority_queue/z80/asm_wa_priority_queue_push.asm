
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int wa_priority_queue_push(wa_priority_queue_t *q, void *item)
;
; Push item into the priority queue.
;
; ===============================================================

SECTION seg_code_wa_priority_queue

PUBLIC asm_wa_priority_queue_push
PUBLIC asm1_wa_priority_queue_push

EXTERN asm_b_array_append_block, __w_heap_sift_up, error_mc

asm_wa_priority_queue_push:

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
   inc hl                      ; hl = & queue.w_array
   
   ld de,2
   call asm_b_array_append_block

   pop bc                      ; bc = item
   jp c, error_mc - 1          ; if no room to add item

asm1_wa_priority_queue_push:

   ld (hl),c
   inc hl
   ld (hl),b                   ; append item to queue
   dec hl

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
   dec bc
   
   inc de
   inc de
   
   jp __w_heap_sift_up
