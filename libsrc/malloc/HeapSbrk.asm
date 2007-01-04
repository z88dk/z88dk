; void HeapSbrk(void *heap, void *addr, unsigned int size)
; 12.2006 aralbrec

XLIB HeapSbrk
XDEF ASMDISP_HEAPSBRK

LIB HeapFree
XREF ASMDISP_HEAPFREE

.HeapSbrk

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af

.asmentry

; Add a block of memory to the specified heap.  The
; block must be at least 4 bytes in size.  Adding a
; block that overlaps with one already in the heap
; will wreck the heap.
;
; enter : de = heap pointer
;         hl = address of available block
;         bc = size of block in bytes >= 4
; exit  : block not added if too small
; uses  : af, bc, de, hl

.MAHeapSbrk

   ld a,b
   or a
   jr nz, sizeok
   ld a,c
   sub 4
   ret c
   
.sizeok

   dec bc
   dec bc
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   jp HeapFree + ASMDISP_HEAPFREE

DEFC ASMDISP_HEAPSBRK = asmentry - HeapSbrk
