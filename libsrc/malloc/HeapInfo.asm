; void HeapInfo(void *heap, unsigned int *total, unsigned int *largest)
; 12.2006 aralbrec

XLIB HeapInfo
LIB MAHeapInfo

.HeapInfo

   ld hl,7
   add hl,sp
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   call MAHeapInfo
   ld hl,2
   add hl,sp
   push de
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ex de,hl
   ld (hl),c
   inc hl
   ld (hl),b
   ex de,hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   pop hl
   ex de,hl
   ld (hl),e
   inc hl
   ld (hl),d
   ret
