; struct adt_Queue *adt_QueueCreate(void)
; 09.2005 aralbrec

XLIB adt_QueueCreate
XREF _u_malloc

; exit : HL = struct adt_Queue * and carry set
;           = 0 and nc if fail

.adt_QueueCreate
   ld hl,6           ; sizeof(struct adt_Queue)
   push hl
   call _u_malloc
   pop de
   ret nc            ; ret with hl = 0 and nc if fail

   ld e,l
   ld d,h
   xor a
   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   scf
   ret
