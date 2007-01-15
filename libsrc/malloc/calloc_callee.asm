; void __CALLEE__ *calloc_callee(unsigned int nobj, unsigned int size) 
; 12.2006 aralbrec

XLIB calloc_callee
XREF ASMDISP_CALLOC_CALLEE

LIB HeapCalloc_callee
XREF _heap, ASMDISP_HEAPCALLOC_CALLEE

.calloc

   pop bc
   pop de
   pop hl
   push bc

.asmentry

; enter : hl = number of objects
;         de = size of each object
; exit  : hl = address of memory block and carry set if successful
;              else 0 and no carry if failed
; uses  : af, bc, de, hl

   ld bc,_heap
   jp HeapCalloc_callee + ASMDISP_HEAPCALLOC_CALLEE

DEFC ASMDISP_CALLOC_CALLEE = asmentry - calloc
