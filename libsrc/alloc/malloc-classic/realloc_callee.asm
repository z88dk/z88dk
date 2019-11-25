; void __CALLEE__ *realloc_callee(void *p, unsigned int size)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC realloc_callee
PUBLIC _realloc_callee
PUBLIC ASMDISP_REALLOC_CALLEE

EXTERN HeapRealloc_callee
EXTERN _heap, ASMDISP_HEAPREALLOC_CALLEE

.realloc_callee
._realloc_callee

   pop hl
   pop bc
IF __CPU_GBZ80__
   EXTERN __z80asm__exsphl
   call __z80asm__exsphl
ELSE
   ex (sp),hl
ENDIF

.asmentry

   ; hl = void *p
   ; bc = size
   
   ld de,_heap
   jp HeapRealloc_callee + ASMDISP_HEAPREALLOC_CALLEE

DEFC ASMDISP_REALLOC_CALLEE = asmentry - realloc_callee
