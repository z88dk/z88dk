; void *calloc(unsigned int nobj, unsigned int size) 
; 12.2006 aralbrec

XLIB calloc
XDEF ASMDISP_CALLOC

LIB l_mult, HeapCalloc
XREF _heap, ASMDISP_HEAPCALLOC

.calloc

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

; enter : hl = number of objects
;         de = size of each object
; exit  : hl = address of memory block and carry set if successful
;              else 0 and no carry if failed
; uses  : af, bc, de, hl

.asmentry

   ld bc,_heap
   jp HeapCalloc + ASMDISP_HEAPCALLOC

DEFC ASMDISP_CALLOC = asmentry - calloc
