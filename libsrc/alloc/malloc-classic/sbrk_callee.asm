; void __CALLEE__ sbrk_callee(void *addr, unsigned int size)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC sbrk_callee
PUBLIC _sbrk_callee
PUBLIC ASMDISP_SBRK_CALLEE

EXTERN HeapSbrk_callee
EXTERN _heap, ASMDISP_HEAPSBRK_CALLEE

.sbrk_callee
._sbrk_callee

   pop hl
   pop bc
IF __CPU_GBZ80__
   EXTERN __z80asm__exsphl
   call __z80asm__exsphl
ELSE
   ex (sp),hl
ENDIF

.asmentry
   
   ; bc = size of block in bytes >- 4
   ; hl = address of block
   
   ld de,_heap
   jp HeapSbrk_callee + ASMDISP_HEAPSBRK_CALLEE

DEFC ASMDISP_SBRK_CALLEE = asmentry - sbrk_callee
