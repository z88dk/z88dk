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
IF __CPU_GBZ80__
   EXTERN __z80asm__exsphl
   call __z80asm__exsphl
ELSE
   ex (sp),hl
ENDIF
   push hl
   jp HeapInfo_callee

