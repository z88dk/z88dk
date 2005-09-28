; int adt_QueuePushBack(struct adt_Queue *q, void *item)
; 09.2005 aralbrec

XLIB adt_QueuePushBack
LIB ADTQueuePushBack

.adt_QueuePushBack
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
   call ADTQueuePushBack
   ret nc
   ld hl,1
   ret
