; void sbrk(void *addr, unsigned int size)
; 12.2006 aralbrec

XLIB sbrk
XDEF ASMDISP_SBRK

LIB HeapSbrk
XREF _heap, ASMDISP_HEAPSBRK

.sbrk

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de

.asmentry
   
   ; bc = size of block in bytes >- 4
   ; hl = address of block
   
   ld de,_heap
   jp HeapSbrk + ASMDISP_HEAPSBRK

DEFC ASMDISP_SBRK = asmentry - sbrk
