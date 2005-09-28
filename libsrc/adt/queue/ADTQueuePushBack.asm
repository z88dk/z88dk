; int adt_QueuePushBack(struct adt_Queue *q, void *item)
; 09.2005 aralbrec

XLIB ADTQueuePushBack
XREF _u_malloc

; enter: HL = struct adt_Queue *
;        DE = item
; exit : HL = 0 and carry reset if memory allocation failed
;        carry set if success

.ADTQueuePushBack
   push de
   push hl
   ld hl,4                 ; sizeof (struct adt_QueueNode)
   call _u_malloc          ; get memory for a queue node
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

   ex de,hl                ; hl = Queue.front
   inc hl
   inc hl
   ld e,(hl)
   inc hl                  ; hl = Queue.back + 1b
   ld d,(hl)               ; de = back QueueNode

   ld a,d
   or e
   jr z, add2emptyqueue

   inc de
   inc de
   ex (sp),hl              ; stack = Queue.back + 1b
   ex de,hl                ; de = new QueueNode *, hl = back QueueNode.next
   ld (hl),e
   inc hl
   ld (hl),d               ; back QueueNode.next = new QueueNode *
   pop hl                  ; hl = Queue.back + 1b
   ld (hl),d
   dec hl
   ld (hl),e               ; Queue.back = new QueueNode
   scf
   ret

.add2emptyqueue
   pop de                  ; de = new QueueNode *
   ld (hl),d
   dec hl
   ld (hl),e               ; Queue.front = Queue.back = new QueueNode
   dec hl
   ld (hl),d
   dec hl
   ld (hl),e
   scf
   ret
