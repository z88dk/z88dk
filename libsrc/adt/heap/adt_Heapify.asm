; void adt_Heapify(void **array, uint n, void *compare)
; 08.2005 aralbrec

XLIB adt_Heapify
LIB ADTHeapify, l_jpiy

.adt_Heapify
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
   ld c,(hl)
   inc hl
   ld b,(hl)
   ex de,hl
   jp ADTHeapify

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
