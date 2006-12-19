; void *calloc(unsigned int nobj, unsigned int size) 
; 12.2006 aralbrec

XLIB calloc
LIB MAHeapCalloc
XREF _heap

.calloc

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld bc,_heap
   jp MAHeapCalloc
