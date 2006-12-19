; void HeapRealloc(void *heap, void *p, unsigned int size)
; 12.2006 aralbrec

XLIB HeapRealloc
LIB MAHeapRealloc

.HeapRealloc

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ex de,hl
   jp MAHeapRealloc
