; uint __FASTCALL__ adt_QueueCount(struct adt_Queue *q)
; 09.2005 aralbrec

XLIB adt_QueueCount

.adt_QueueCount

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ret


