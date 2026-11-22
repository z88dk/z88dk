; void *adt_QueueFront(struct adt_Queue *q)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC adt_QueueFront
PUBLIC _adt_QueueFront

; enter: HL = struct adt_Queue *
; exit : HL = peek at top item or 0 and carry reset if queue empty

.adt_QueueFront
._adt_QueueFront

   inc hl
   inc hl

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   ret z

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   scf
   ret
