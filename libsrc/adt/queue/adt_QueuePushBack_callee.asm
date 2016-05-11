; int __CALLEE__ adt_QueuePushBack_callee(struct adt_Queue *q, void *item)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC adt_QueuePushBack_callee
PUBLIC _adt_QueuePushBack_callee
PUBLIC ASMDISP_ADT_QUEUEPUSHBACK_CALLEE

EXTERN _u_malloc

.adt_QueuePushBack_callee
._adt_QueuePushBack_callee

   pop hl
   pop de
   ex (sp),hl

.asmentry

; enter: HL = struct adt_Queue *
;        DE = item
; exit : HL = 0 and carry reset if memory allocation failed
;        carry set if success

   push de
   push hl
   ld hl,4                 ; sizeof (struct adt_QueueNode)
   push hl
   call _u_malloc          ; get memory for a queue node
   pop de
   pop de                  ; de = struct adt_Queue *
   pop bc                  ; bc = item
   ret nc                  ; ret with hl = 0 if alloc failed

   push hl                 ; stack = new QueueNode*
   ld (hl),c               ; store item in new QueueNode container
   inc hl
   ld (hl),b
   inc hl
   xor a
   ld (hl),a               ; QueueNode.next = 0
   inc hl
   ld (hl),a

   ex de,hl                ; hl = Queue.count
   ld a,(hl)
   inc (hl)                ; count++
   inc hl
   ld c,(hl)
   jr nz, nohi
   inc (hl)
   
.nohi

   or c                    ; Z flag if no items in queue
   inc hl                  ; hl = Queue.front

   pop bc                  ; bc = new QueueNode
   jp nz, Qnotempty
   ld (hl),c               ; an empty queue so make
   inc hl                  ; Queue.front = new QueueNode
   ld (hl),b
   dec hl

.Qnotempty
   inc hl
   inc hl                  ; hl = Queue.back
   ld e,(hl)               ; de = current last QueueNode
   ld (hl),c               ; Queue.back = new QueueNode
   inc hl
   ld d,(hl)
   ld (hl),b
   
   ex de,hl                ; hl = last QueueNode
   inc hl
   inc hl
   ld (hl),c               ; last QueueNode.next = new QueueNode
   inc hl
   ld (hl),b
   scf
   ret

DEFC ASMDISP_ADT_QUEUEPUSHBACK_CALLEE = # asmentry - adt_QueuePushBack_callee
