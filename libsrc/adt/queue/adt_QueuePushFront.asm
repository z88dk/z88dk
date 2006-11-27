; int adt_QueuePushFront(struct adt_Queue *q, void *item)
; 11.2006 aralbrec

XLIB adt_QueuePushFront
LIB ADTQueuePushFront

.adt_QueuePushFront
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   call ADTQueuePushFront
   ret nc
   ld hl,1
   ret
