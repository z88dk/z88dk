; void mallinfo(unsigned int *total, unsigned int *largest)
; 12.2006 aralbrec

XLIB mallinfo
LIB MAHeapInfo
XREF _heap

.mallinfo

   ld hl,_heap
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
