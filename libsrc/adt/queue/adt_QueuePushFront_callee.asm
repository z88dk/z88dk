; int __CALLEE__ adt_QueuePushFront_callee(struct adt_Queue *q, void *item)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC adt_QueuePushFront_callee
PUBLIC _adt_QueuePushFront_callee
PUBLIC ASMDISP_ADT_QUEUEPUSHFRONT_CALLEE

EXTERN _u_malloc

.adt_QueuePushFront_callee
._adt_QueuePushFront_callee

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
   
   ex de,hl                ; hl = Queue.count, de = new QueueNode.next
   ld a,(hl)
   inc (hl)                ; count++
   inc hl
   ld c,(hl)
   jp nz, nohi
   inc (hl)
   
.nohi

   or c                    ; Z flag if 0 items in Queue
   inc hl                  ; hl = Queue.front
   
   ldi                     ; copy Queue.front into new QueueNode.next
   ld a,(hl)               ; hl = Queue.front + 1b
   ld (de),a
   pop de                  ; de = new QueueNode
   ld (hl),d               ; Queue.front = new QueueNode
   dec hl
   ld (hl),e
   scf
   ret nz                  ; ret if this is not the only item
   
   inc hl                  ; otherwise make back ptr point at item too
   inc hl                  ; hl = Queue.back
   ld (hl),e
   inc hl
   ld (hl),d
   ret

DEFC ASMDISP_ADT_QUEUEPUSHFRONT_CALLEE = # asmentry - adt_QueuePushFront_callee
