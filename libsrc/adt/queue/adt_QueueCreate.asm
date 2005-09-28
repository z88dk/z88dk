; struct adt_Queue *adt_QueueCreate(void)
; 09.2005 aralbrec

XLIB adt_Queue
XREF _u_malloc

; exit : HL = struct adt_Queue * and carry set
;           = 0 and nc if fail

.adt_Queue
   ld hl,4           ; sizeof(struct adt_Queue)
   call _u_malloc
   ret nc            ; ret with hl = 0 and nc if fail

   ld e,l
   ld d,h
   xor a
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   ex de,hl
   scf
   ret
