; void *HeapAlloc(void *heap, unsigned int size)
; 12.2006 aralbrec

XLIB HeapAlloc
LIB MAHeapAlloc

.HeapAlloc

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
   jp MAHeapAlloc
