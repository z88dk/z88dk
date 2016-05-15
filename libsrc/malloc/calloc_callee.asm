; void __CALLEE__ *calloc_callee(unsigned int nobj, unsigned int size) 
; 12.2006 aralbrec

SECTION code_clib
PUBLIC calloc_callee
PUBLIC _calloc_callee
EXTERN ASMDISP_CALLOC_CALLEE

EXTERN HeapCalloc_callee
EXTERN _heap, ASMDISP_HEAPCALLOC_CALLEE

.calloc_callee
._calloc_callee

   pop hl
   pop de
   ex (sp),hl

.asmentry

; enter : hl = number of objects
;         de = size of each object
; exit  : hl = address of memory block and carry set if successful
;              else 0 and no carry if failed
; uses  : af, bc, de, hl

   ld bc,_heap
   jp HeapCalloc_callee + ASMDISP_HEAPCALLOC_CALLEE

DEFC ASMDISP_CALLOC_CALLEE = # asmentry - calloc_callee
