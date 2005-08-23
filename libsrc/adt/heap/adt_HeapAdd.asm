; void adt_HeapAdd(void *item, void **array, uint *n, void *compare)
; 08.2005 aralbrec

XLIB adt_HeapAdd
LIB ADTHeapAdd, l_jpiy

.adt_HeapAdd
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld iyl,e
   ld iyh,d
   ld ix,compare
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ex de,hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc bc
   ld (hl),b
   dec hl
   ld (hl),c
   ex de,hl
   ld e,c
   ld d,b
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ex de,hl
   jp ADTHeapAdd

.compare
   push bc
   push de
   push hl
   call l_jpiy
   rl l
   pop hl
   pop de
   pop bc
   ret
