; void *realloc(void *p, unsigned int size)
; 12.2006 aralbrec

XLIB realloc
LIB MAHeapRealloc
XREF _heap

.realloc

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld de,_heap
   jp MAHeapRealloc
