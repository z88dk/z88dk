; void HeapFree(void *heap, void *addr)
; 12.2006 aralbrec

XLIB HeapFree
LIB MAHeapFree

.HeapFree

   ld hl,5
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   jp MAHeapFree
