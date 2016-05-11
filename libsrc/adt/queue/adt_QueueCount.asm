; uint __FASTCALL__ adt_QueueCount(struct adt_Queue *q)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC adt_QueueCount
PUBLIC _adt_QueueCount

.adt_QueueCount
._adt_QueueCount

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ret


