; void __CALLEE__ sbrk_callee(void *addr, unsigned int size)
; 12.2006 aralbrec

XLIB sbrk_callee
XDEF ASMDISP_SBRK_CALLEE

LIB HeapSbrk_callee
XREF _heap, ASMDISP_HEAPSBRK_CALLEE

.sbrk_callee

   pop hl
   pop bc
   ex (sp),hl

.asmentry
   
   ; bc = size of block in bytes >- 4
   ; hl = address of block
   
   ld de,_heap
   jp HeapSbrk_callee + ASMDISP_HEAPSBRK_CALLEE

DEFC ASMDISP_SBRK_CALLEE = asmentry - sbrk_callee
