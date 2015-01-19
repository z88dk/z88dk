; struct adt_Queue *adt_QueueCreate(void)
; 09.2005 aralbrec

PUBLIC adt_QueueCreate

EXTERN l_setmem
EXTERN _u_malloc

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
   call l_setmem-11
   ex de,hl
   scf
   ret
