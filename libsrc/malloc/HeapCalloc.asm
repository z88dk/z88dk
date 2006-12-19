; void *HeapCalloc(void *heap, unsigned int nobj, unsigned int size)
; 12.2006 aralbrec

XLIB HeapCalloc
LIB MAHeapCalloc

.HeapCalloc

   ld hl,7
   add hl,sp
   ld b,(hl)
   dec hl
   ld c,(hl)
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   jp MAHeapCalloc
