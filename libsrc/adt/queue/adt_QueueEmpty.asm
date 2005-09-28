; int adt_QueueEmpty(struct adt_Queue *q);
; 09.2005 aralbrec

XLIB adt_QueueEmpty

; exit : HL = non zero and carry reset if queue empty

.adt_QueueEmpty
   ld a,(hl)
   inc hl
   or (hl)
   ld hl,1
   ret z
   dec l
   scf
   ret
