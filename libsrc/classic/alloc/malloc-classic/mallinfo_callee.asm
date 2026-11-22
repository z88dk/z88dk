; void __CALLEE__ mallinfo_callee(unsigned int *total, unsigned int *largest)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC mallinfo_callee
PUBLIC _mallinfo_callee

EXTERN HeapInfo_callee
EXTERN _heap

.mallinfo_callee
._mallinfo_callee

   ld hl,_heap
   ex (sp),hl
   push hl
   jp HeapInfo_callee

