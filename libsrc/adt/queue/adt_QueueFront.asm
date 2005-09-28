; void *adt_QueueFront(struct adt_Queue *q)
; 09.2005 aralbrec

XLIB adt_QueueFront

; enter: HL = struct adt_Queue *
; exit : HL = peek at top item or 0 and carry reset if queue empty

.adt_QueueFront
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl
   ld a,h
   or l
   ret z
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl
   scf
   ret
