; void *adt_HeapExtract(void **array, uint *n, void *compare)
; 08.2005 aralbrec

XLIB adt_HeapExtract
LIB ADTHeapExtract, l_jpiy

.adt_HeapExtract
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
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ex de,hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ex de,hl
   call ADTHeapExtract
   jr nc, noextract
   push hl
   ld hl,6
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   dec de
   ld (hl),d
   dec hl
   ld (hl),e
   pop hl
   ret

.noextract
   ld hl,0
   ret

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
