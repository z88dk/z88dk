; void __CALLEE__ *calloc_callee(unsigned int nobj, unsigned int size) 
; 12.2006 aralbrec

SECTION code_clib
PUBLIC calloc_callee
PUBLIC _calloc_callee
EXTERN asm_calloc

EXTERN asm_HeapCalloc
EXTERN _heap

.calloc_callee
._calloc_callee

   pop hl
   pop de
   ex (sp),hl

.asm_calloc

; enter : hl = number of objects
;         de = size of each object
; exit  : hl = address of memory block and carry set if successful
;              else 0 and no carry if failed
; uses  : af, bc, de, hl

   ld bc,_heap
   jp asm_HeapCalloc

